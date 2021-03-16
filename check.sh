#!/usr/bin/env bash

set -euo pipefail

_run() {
  local -r db_file="${1:-qwer.db}"

  sqlite3 -readonly -init .sqliterc "${db_file}" <<-SQL

.echo off
PRAGMA foreign_keys = ON;

SELECT * FROM v_plugins_missing;
SELECT * FROM v_packages_missing;

SQL
}

_run "$@"
