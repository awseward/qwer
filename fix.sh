#!/usr/bin/env bash

set -euo pipefail

_commands() {
  local -r db_file="${1:-qwer.db}"

  sqlite3 -readonly "${db_file}" <<-SQL
.echo   off
.header off
.mode   list
PRAGMA foreign_keys = ON;

SELECT "Command" FROM v_plugins_missing
  UNION ALL
  SELECT "Command" FROM v_packages_missing
;
SQL
}

_run() {
  _commands "$@" | xargs -I{} -t -L1 /usr/bin/env bash -c '{}'
}

_run "$@"
