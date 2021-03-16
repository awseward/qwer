#!/usr/bin/env bash

set -euo pipefail

_run() {
  local -r db_file="${1:-qwer.db}"

  sqlite3 -init schema.sql "${db_file}" ''

  ./populate_plugins_added.sh
  ./populate_packages_installed.sh
}

_run "$@"
