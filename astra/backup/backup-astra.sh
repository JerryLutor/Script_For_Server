#!/usr/bin/env bash
#
# backup-astra.sh — скачивает исполняемые сборки Cesbo Astra с сайта разработчика
# и поддерживает локальный архив в актуальном состоянии.
#
# Сборки лежат по адресу  $BASE_URL/astra-ГГММДД  (ГГ=год, ММ=месяц, ДД=день, всё по 2 цифры).
# Листинга каталога нет (403), поэтому даты перебираются от START_DATE до сегодня.
#   существующая дата -> HTTP 200 (application/octet-stream, ELF-бинарь ~7-8 МБ)
#   отсутствующая     -> HTTP 404
#
# Логика инкрементальности:
#   * файл уже есть локально      -> пропуск без запроса к сети;
#   * дата раньше отмечена как 404 и старше RECHECK_DAYS -> пропуск (кэш state/missing.txt);
#   * остальные даты проверяются; при 200 файл скачивается атомарно (.part -> mv).
#
# Смена START_DATE НЕ удаляет уже скачанные файлы — архив только пополняется.
#
# Использование:
#   ./backup-astra.sh [--start ГГГГ-ММ-ДД] [--archive ПУТЬ] [--recheck-days N] [--full] [--delay СЕК]
#   --full   игнорировать кэш отсутствующих дат и перепроверить весь диапазон
#
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
. "$DIR/lib.sh"

usage() { sed -n '2,20p' "$0" | sed 's/^# \{0,1\}//'; }

FULL=0
END_DATE=""
while [ $# -gt 0 ]; do
  case "$1" in
    --start)        START_DATE="$2"; shift 2;;
    --start=*)      START_DATE="${1#*=}"; shift;;
    --end)          END_DATE="$2"; shift 2;;
    --end=*)        END_DATE="${1#*=}"; shift;;
    --archive)      ARCHIVE_DIR="$2"; shift 2;;
    --archive=*)    ARCHIVE_DIR="${1#*=}"; shift;;
    --recheck-days) RECHECK_DAYS="$2"; shift 2;;
    --delay)        REQUEST_DELAY="$2"; shift 2;;
    --full)         FULL=1; shift;;
    -h|--help)      usage; exit 0;;
    *) die "неизвестный аргумент: $1 (см. --help)";;
  esac
done

require_tools curl date sort
ensure_date "$START_DATE"
[ -n "$END_DATE" ] && ensure_date "$END_DATE"

mkdir -p "$ARCHIVE_DIR" "$STATE_DIR"
MISSING_FILE="$STATE_DIR/missing.txt"
touch "$MISSING_FILE"

today="${END_DATE:-$(date +%Y-%m-%d)}"       # конец диапазона: --end или сегодня
today_cmp="$(date -d "$today" +%Y%m%d)"
cutoff="$(date -d "$today -$RECHECK_DAYS days" +%Y%m%d)"   # даты старше — доверяем кэшу

# Загрузка кэша отсутствующих дат в ассоциативный массив.
declare -A MISS
while IFS= read -r d; do
  d="${d%$'\r'}"
  [ -n "$d" ] && MISS["$d"]=1
done < "$MISSING_FILE"

log "Astra backup: диапазон $START_DATE .. $today, архив: $ARCHIVE_DIR"
[ "$FULL" -eq 1 ] && log "Режим --full: кэш отсутствующих дат игнорируется."

have=0; new=0; miss=0; err=0; probed=0

# Скачивание одной сборки. Печатает: OK | MISS | ERR<код>
fetch() {
  local url="$1" dest="$2" tmp="$2.part" code
  # Без -f: 404 отдаёт код 404 и exit 0; реальные обрывы (partial) дают ненулевой exit -> ветка ошибки.
  if code="$(curl -sS --max-time "$HTTP_TIMEOUT" --retry 2 --retry-delay 3 \
                  -o "$tmp" -w '%{http_code}' "$url")"; then
    case "$code" in
      200) mv -f "$tmp" "$dest"; echo "OK";;
      404) rm -f "$tmp"; echo "MISS";;
      *)   rm -f "$tmp"; echo "ERR$code";;
    esac
  else
    rm -f "$tmp"; echo "ERRnet"
  fi
}

cur="$START_DATE"
while [ "$(date -d "$cur" +%Y%m%d)" -le "$today_cmp" ]; do
  cmp="$(date -d "$cur" +%Y%m%d)"
  ymd="$(date -d "$cur" +%y%m%d)"
  name="${NAME_PREFIX}${ymd}"
  dest="$ARCHIVE_DIR/$name"

  if [ -s "$dest" ]; then
    have=$((have+1))
    unset 'MISS[$cmp]'
  elif [ "$FULL" -eq 0 ] && [ -n "${MISS[$cmp]:-}" ] && [ "$cmp" -lt "$cutoff" ]; then
    miss=$((miss+1))
  else
    probed=$((probed+1))
    case "$(fetch "$BASE_URL/$name" "$dest")" in
      OK)    log "СКАЧАНО  $name ($(du -h "$dest" 2>/dev/null | cut -f1))"; new=$((new+1)); unset 'MISS[$cmp]';;
      MISS)  miss=$((miss+1)); MISS["$cmp"]=1;;
      ERR*)  warn "ошибка загрузки $name — попробую в следующий раз"; err=$((err+1));;
    esac
    [ "$REQUEST_DELAY" != "0" ] && sleep "$REQUEST_DELAY" || true
  fi

  cur="$(date -d "$cur +1 day" +%Y-%m-%d)"
done

# Сохранить обновлённый кэш отсутствующих дат.
if [ "${#MISS[@]}" -gt 0 ]; then
  printf '%s\n' "${!MISS[@]}" | sort -u > "$MISSING_FILE"
else
  : > "$MISSING_FILE"
fi

total="$(find "$ARCHIVE_DIR" -maxdepth 1 -type f -name "${NAME_PREFIX}*" 2>/dev/null | wc -l | tr -d ' ')"
log "Итог: новых=$new, уже было=$have, отсутствует=$miss, ошибок=$err, запросов=$probed. Всего в архиве: $total."
[ "$err" -eq 0 ]
