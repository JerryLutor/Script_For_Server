#!/usr/bin/env bash
# sync-all.sh — скачать новые сборки, затем выгрузить новые на FTP.
# Удобно ставить в cron. Все аргументы передаются в backup-astra.sh.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
"$DIR/backup-astra.sh" "$@"
"$DIR/upload-ftp.sh"
