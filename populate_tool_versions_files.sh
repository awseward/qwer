#!/usr/bin/env bash

set -euo pipefail

_filepaths() {
  echo "${HOME}/.tool-versions"
  find "${HOME}/projects" -maxdepth 3 -name '.tool-versions'
}

_as_values() {
  while read -r filepath; do echo "(\'${filepath}\')"; done \
  | xargs \
  | sed -e "s/')/'),/g" \
  | sed -e 's/,$//g'
}

_run() {
  local -r db_file="${1:-qwer.db}"

  sqlite3 "${db_file}" <<-SQL
.echo on
PRAGMA foreign_keys = ON;

BEGIN;

  INSERT OR REPLACE INTO tool_versions_files (absolute_path)
    VALUES $(_filepaths | _as_values);

COMMIT;
SQL
}

_run "$@"
