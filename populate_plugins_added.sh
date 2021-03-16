#!/usr/bin/env bash

set -euo pipefail

_run() {
  local -r db_file="${1:-qwer.db}"

  asdf plugin list --urls --refs \
    | while read -r line; do
        # shellcheck disable=SC2086
        # shellcheck disable=SC2116
        # shellcheck disable=SC2206
        # shellcheck disable=SC2207
        cols=( $(echo $line) )
        echo "(\'${cols[0]}\', \'${cols[1]}\', \'${cols[2]}\', \'${cols[3]}\')"
      done \
    | xargs \
    | sed -e "s/')/'),/g" \
    | sed -e 's/,$//g' \
    | while read -r values; do
        sqlite3 "${db_file}" <<-SQL
.echo on
PRAGMA foreign_keys = ON;

BEGIN;

  INSERT INTO plugins_added (name, url, ref1, ref2) VALUES ${values}
    ON CONFLICT(name) DO UPDATE SET
      url  = excluded.url,
      ref1 = excluded.ref1,
      ref2 = excluded.ref2
  ;

COMMIT;
SQL
      done
}

_run "$@"
