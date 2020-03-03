#!/usr/bin/env bash
#
# Connect to MySQL

declare -r COLOR_RED="\e[33;41;1m"
declare -r COLOR_OFF="\e[m"
declare -r DB_CONFIG_PATH='path/to/database.conf'
# check file exists or not
if [ ! -f "${DB_CONFIG_PATH}" ]; then
  echo -e "${COLOR_RED}[error] \"${DB_CONFIG_PATH}\" does not exist.${COLOR_OFF}"
  exit 1
fi

declare -r SECTION=$1
# check argument
if [ -z "$SECTION" ]; then
  echo -e "${COLOR_RED}[error] Please set section name as command argument.${COLOR_OFF}"
  exit 1
fi


#######################################
# Parse DB config by python
# Globals:
#   DB_CONFIG_PATH
#   SECTION
# Arguments:
#   None
# Returns:
#   None
#######################################
function parse_ini_file () {

  python3 <<'EOF' - "${DB_CONFIG_PATH}" "${SECTION}"

import sys
import configparser

file_path    = sys.argv[1]
section_name = sys.argv[2]

config = configparser.ConfigParser()

config.read(file_path)

try:
    details = config[section_name]
except KeyError:
    sys.exit(1)

db_option = \
    '[client]\\nhost={host}\\nport={port}\\ndatabase={database}\\nuser={user}\\npassword={password}\\n'\
    .format(\
        host=details['host'],\
        port=details['port'],\
        database=details['database'],\
        user=details['user'],\
        password=details['password']\
    )

sys.stdout.write(db_option)
sys.exit(0)

EOF


}

db_option=$(parse_ini_file)

if [ $? -ne 0 ]; then
  echo -e "${COLOR_RED}[error] Section \"${SECTION}\" does not exist in config file.${COLOR_OFF}"
  exit 1
fi

mysql --defaults-extra-file=<(echo -e ${db_option})