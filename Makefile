db_file = qwer_dev.db

# ---

db-ro: ${db_file}
	sqlite3 -readonly -init ./.sqliterc "${db_file}"

db: ${db_file}
	sqlite3 -init ./.sqliterc "${db_file}"

check-missing: ${db_file}
	./check_missing.sh "${db_file}"

check-outdated: ${db_file}
	./check_outdated.sh "${db_file}"

check-all: ${db_file}
	./check_missing.sh  "${db_file}"
	./check_outdated.sh "${db_file}"

fix-missing: ${db_file}
	./fix_missing.sh "${db_file}"

fix-outdated: ${db_file}
	./fix_outdated.sh "${db_file}"

fix-all: ${db_file}
	./fix_missing.sh  "${db_file}"
	./fix_outdated.sh "${db_file}"

${db_file}:
	./db_up.sh "${db_file}"
