#!/usr/bin/env bash
# lib.sh — общие функции и загрузка конфигурации.
# Источается (source) из backup-astra.sh и upload-ftp.sh, самостоятельно не запускается.

# Требуется bash >= 4 (ассоциативные массивы).
if [ -z "${BASH_VERSINFO:-}" ] || [ "${BASH_VERSINFO[0]}" -lt 4 ]; then
  echo "ОШИБКА: нужен bash >= 4 (в macOS поставьте современный bash через brew)." >&2
  exit 1
fi

# Каталог, где лежат скрипты (корректно работает и при source).
ASTRA_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --- Значения по умолчанию. Их можно переопределить в config.env. ---
BASE_URL="http://cesbo.com/and"      # базовый URL каталога сборок Astra
START_DATE="2025-01-01"              # с какой даты качать (включительно), ГГГГ-ММ-ДД
ARCHIVE_DIR="$ASTRA_DIR/archive"     # куда складывать сборки
STATE_DIR="$ASTRA_DIR/state"         # служебные файлы (кэш отсутствующих дат)
RECHECK_DAYS=45                      # повторно проверять «отсутствующие» даты за последние N дней
HTTP_TIMEOUT=120                     # таймаут одного curl-запроса, сек
REQUEST_DELAY=0                      # пауза между запросами, сек (например 0.2, чтобы не нагружать сервер)
NAME_PREFIX="astra-"                 # префикс имени файла: astra-ГГММДД

# --- FTP (для upload-ftp.sh) ---
FTP_HOST=""                          # адрес FTP-сервера
FTP_PORT=21                          # порт (21 обычный / 990 у неявного FTPS)
FTP_USER=""                          # логин
FTP_PASS=""                          # пароль
FTP_DIR="/"                          # каталог назначения на сервере
FTP_TLS=0                            # 1 = FTPS (explicit, AUTH TLS, обязательный)

# Загрузка config.env, если он есть (значения из файла переопределяют дефолты выше).
_ASTRA_CFG="${ASTRA_CONFIG:-$ASTRA_DIR/config.env}"
if [ -f "$_ASTRA_CFG" ]; then
  # shellcheck disable=SC1090
  . "$_ASTRA_CFG"
fi

# --- Логирование ---
log()  { printf '%s  %s\n'    "$(date +'%Y-%m-%d %H:%M:%S')" "$*"; }
warn() { printf '%s  WARN %s\n' "$(date +'%Y-%m-%d %H:%M:%S')" "$*" >&2; }
die()  { printf '%s  ОШИБКА %s\n' "$(date +'%Y-%m-%d %H:%M:%S')" "$*" >&2; exit 1; }

# Проверка, что дата вида ГГГГ-ММ-ДД разбирается GNU date.
ensure_date() {
  date -d "$1" +%Y%m%d >/dev/null 2>&1 || die "неверная дата: '$1' (ожидается ГГГГ-ММ-ДД)"
}

# Проверка наличия обязательных утилит.
require_tools() {
  local t
  for t in "$@"; do
    command -v "$t" >/dev/null 2>&1 || die "не найдена утилита: $t"
  done
}
