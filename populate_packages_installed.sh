#!/usr/bin/env bash

set -euo pipefail

_run() {
  local -r db_file="${1:-qwer.db}"

  sqlite3 -readonly "${db_file}" 'SELECT name FROM plugins_added ORDER BY 1;' \
  | while read -r lang; do
      # shellcheck disable=SC2207
      arr=( $(asdf list "${lang}" 2>/dev/null ) )

      for version in "${arr[@]}"; do
        echo "(\'${lang}\', \'${version}\')"
      done
    done \
  | xargs \
  | sed -e "s/')/'),/g" \
  | sed -e 's/,$//g' \
  | while read -r values; do
      sqlite3 "${db_file}" <<-SQL
.echo on
PRAGMA foreign_keys = ON;

BEGIN;

  INSERT OR REPLACE INTO packages_installed (plugin_name, version)
    VALUES ${values};

COMMIT;
SQL
    done
}

_run "$@"
