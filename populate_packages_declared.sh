#!/usr/bin/env bash

set -euo pipefail

_run() {
  local -r db_file="${1:-qwer.db}"

  sqlite3 -readonly "${db_file}" 'SELECT absolute_path FROM tool_versions_files ORDER BY 1;' \
    | while read -r filepath; do
         sort -u "${filepath}" | while read -r line; do
           # shellcheck disable=SC2207
           arr=( $(echo "${line}" | tr ' ' "\n") )
           plugin_name="${arr[0]}"
           version="${arr[1]}"

           echo "(\'${filepath}\', \'${plugin_name}\', \'${version}\')"
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

  INSERT OR REPLACE INTO packages_declared (absolute_path, plugin_name, version)
    VALUES ${values};

COMMIT;
SQL
      done
}

_run "$@"
