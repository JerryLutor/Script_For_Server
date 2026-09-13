#!/usr/bin/env bash
#
# upload-ftp.sh — выгружает сборки Astra из локального архива на FTP-сервер,
# заливая только новые файлы (сравнение по имени со списком на сервере).
#
# Настройки FTP берутся из config.env (FTP_HOST/FTP_PORT/FTP_USER/FTP_PASS/FTP_DIR/FTP_TLS).
# Пароль передаётся в curl через временный конфиг с правами 600, а не в командной строке,
# чтобы не светиться в списке процессов.
#
# Использование:
#   ./upload-ftp.sh [--verify] [--archive ПУТЬ]
#   --verify  до пропуска сверять размер уже лежащего на сервере файла с локальным
#             и перезаливать при несовпадении (лечит битые/недокачанные ранее заливки)
#
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
. "$DIR/lib.sh"

usage() { sed -n '2,14p' "$0" | sed 's/^# \{0,1\}//'; }

VERIFY=0
while [ $# -gt 0 ]; do
  case "$1" in
    --verify)     VERIFY=1; shift;;
    --archive)    ARCHIVE_DIR="$2"; shift 2;;
    --archive=*)  ARCHIVE_DIR="${1#*=}"; shift;;
    -h|--help)    usage; exit 0;;
    *) die "неизвестный аргумент: $1 (см. --help)";;
  esac
done

require_tools curl awk
[ -n "$FTP_HOST" ] || die "не задан FTP_HOST (заполните config.env)"
[ -n "$FTP_USER" ] || die "не задан FTP_USER (заполните config.env)"
[ -d "$ARCHIVE_DIR" ] || die "нет каталога архива: $ARCHIVE_DIR"

# Нормализуем удалённый каталог к виду /path/  (или /).
rdir="/${FTP_DIR#/}"; rdir="${rdir%/}/"
base="ftp://${FTP_HOST}:${FTP_PORT}${rdir}"

sslopt=()
[ "$FTP_TLS" = "1" ] && sslopt=(--ssl-reqd)

# Креды — во временный конфиг curl (chmod 600), удаляется по выходу.
cfg="$(mktemp)"; chmod 600 "$cfg"
trap 'rm -f "$cfg"' EXIT
printf 'user = "%s:%s"\n' "$FTP_USER" "$FTP_PASS" > "$cfg"

CURL=(curl -sS --max-time "$HTTP_TIMEOUT" -K "$cfg" "${sslopt[@]}")

log "FTP выгрузка -> $base (архив: $ARCHIVE_DIR)"

# Список файлов на сервере (если каталога ещё нет — считаем список пустым).
declare -A REMOTE
while IFS= read -r f; do
  f="${f%$'\r'}"
  [ -n "$f" ] && REMOTE["$(basename "$f")"]=1
done < <("${CURL[@]}" --list-only "$base" 2>/dev/null || true)

# Размер файла на сервере (через FTP SIZE); пусто, если недоступно.
remote_size() { "${CURL[@]}" -I "$base$1" 2>/dev/null | awk 'tolower($1)=="content-length:"{print $2}' | tr -d '\r'; }

up=0; skip=0; err=0
shopt -s nullglob
for path in "$ARCHIVE_DIR"/${NAME_PREFIX}*; do
  [ -f "$path" ] || continue
  case "$path" in *.part) continue;; esac
  name="$(basename "$path")"

  if [ -n "${REMOTE[$name]:-}" ]; then
    if [ "$VERIFY" -eq 1 ]; then
      lsz="$(wc -c < "$path" | tr -d ' ')"
      rsz="$(remote_size "$name")"
      if [ -n "$rsz" ] && [ "$rsz" = "$lsz" ]; then
        skip=$((skip+1)); continue
      fi
      warn "размер на сервере ($rsz) != локальному ($lsz) для $name — перезаливаю"
    else
      skip=$((skip+1)); continue
    fi
  fi

  if "${CURL[@]}" --ftp-create-dirs -T "$path" "$base$name"; then
    log "ЗАЛИТО   $name"; up=$((up+1))
  else
    warn "не удалось залить $name"; err=$((err+1))
  fi
done

log "Итог FTP: залито=$up, уже было=$skip, ошибок=$err."
[ "$err" -eq 0 ]
