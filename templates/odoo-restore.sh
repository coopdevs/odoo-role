#!/bin/bash

# Exit script if command fails
# -u stops the script on unset variables
# -e stops the script on errors
# -o pipefail stops the script if a pipe fails
set -e


# Get script name
SCRIPT=$(basename "$0")

# Display Help
Help() {
  echo
  echo "$SCRIPT"
  echo
  echo "Description: Restore odoo database."
  echo "Syntax: $SCRIPT [-p|-d|-f|-h|-r|help]"
  echo "Example: $SCRIPT -p secret -d odoo -f /tmp/odoo.zip -h https://odoo.example.org"
  echo "options:"
  echo "  -p    Odoo master password. Defaults to \$ODOO_MASTER_PASSWORD env var and 'admin'."
  echo "  -d    Database name. Defaults to filename."
  echo "  -f    Odoo database backup file. Defaults to '/var/tmp/odoo.zip'"
  echo "  -h    Odoo host. Defaults to 'http://localhost:8069'"
  echo "  -r    Replace existing database."  
  echo "  help  Show $SCRIPT manual."
  echo
}

# Show help and exit
if [[ $1 == 'help' ]]; then
    Help
    exit
fi

# Initialise option flag with a false value
REPLACE='false'

# Process params
while getopts ":r :p: :d: :f: :h:" opt; do
  case $opt in
    r) REPLACE='true'
    ;;
    h) ODOO_HOST="$OPTARG"
    ;;
    p) PASSWORD="$OPTARG"
    ;;
    d) DATABASE="$OPTARG"
    ;;
    f) FILE="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    Help
    ;;
  esac
done

# Fallback to environment vars and default values
: ${PASSWORD:=${ODOO_MASTER_PASSWORD:='admin'}}
: ${FILE:='/var/tmp/odoo.zip'}
: ${ODOO_HOST:='http://localhost:8069'}
FILENAME=$(basename -- "$FILE")
: ${DATABASE:="${FILENAME%%.*}"}

# Verify variables
[[ "$ODOO_HOST" == http* ]]  || { echo "Parameter -h|host must start with 'http/s'" ; exit 1; }
[[ "${FILENAME##*.}" != "zip" ]] && { echo "Parameter -f|filename must end with '.zip'" ; exit 1; }

# Validate zip file
unzip -q -t $FILE

if $REPLACE; then
  echo "Deleting Odoo database $DATABASE ..."

  curl \
    --silent \
    -F "master_pwd=${PASSWORD}" \
    -F "name=${DATABASE}" \
    ${ODOO_HOST%/}/web/database/drop | grep -q -E 'Internal Server Error|Redirecting...'
fi

# Start restore
echo "Requesting restore for Odoo database $DATABASE ..."

# Request restore with curl
CURL=$(curl \
  -F "master_pwd=$PASSWORD" \
  -F "name=$DATABASE" \
  -F backup_file=@$FILE \
  -F 'copy=true' \
  "${ODOO_HOST%/}/web/database/restore")
  
(echo $CURL | grep -q 'Redirecting...') || (echo "The restore failed:"; echo $CURL | grep error; exit 1)

echo "The restore for Odoo database $DATABASE has finished."