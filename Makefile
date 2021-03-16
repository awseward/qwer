db_file = qwer_dev.db

# ---

db: ${db_file}
	sqlite3 -init ./.sqliterc "${db_file}"

${db_file}:
	./db_up.sh "${db_file}"
