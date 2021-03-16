db_file = qwer_dev.db

# ---

db-ro: ${db_file}
	sqlite3 -readonly -init ./.sqliterc "${db_file}"

db: ${db_file}
	sqlite3 -init ./.sqliterc "${db_file}"

check: ${db_file}
	./check.sh "${db_file}"

${db_file}:
	./db_up.sh "${db_file}"
