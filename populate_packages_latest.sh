#!/usr/bin/env bash

set -euo pipefail

_run() {
  local -r db_file="${1:-qwer.db}"

  sqlite3 -readonly "${db_file}" 'SELECT DISTINCT plugin_name FROM packages_declared ORDER BY 1;' \
    | while read -r plugin_name; do
        version="$(xargs -t asdf latest <<< "${plugin_name}")"

        if [ "${version}" != '' ]; then
          echo "(\'${plugin_name}\', \'${version}\')"
        else
          >&2 echo "Had some issue(s) resolving latest version for '${plugin_name}'. Try \`asdf latest ${plugin_name}\`…"
        fi
      done \
    | xargs \
    | sed -e "s/')/'),/g" \
    | sed -e 's/,$//g' \
    | while read -r values; do
        sqlite3 "${db_file}" <<-SQL
.echo on
PRAGMA foreign_keys = ON;

BEGIN;

  -- Insert values
  INSERT INTO packages_latest (plugin_name, version) VALUES ${values}
    ON CONFLICT(plugin_name) DO UPDATE SET version = excluded.version;
  ;

  -- Remove langs we couldn't resolve a latest for
  DELETE FROM packages_latest WHERE TRIM(version) = '';

COMMIT;
SQL
      done
}

_run "$@"
