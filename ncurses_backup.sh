#!/bin/bash

# First type the location for backup file
# Click SPACE bar to go to particular directory
# Click ENTER to select file/directory path to be compressed
# Choose OK to proceed backup

FILE="."
CURRENT_DIRECTORY="/"
BACKUP_PATHS=()
NOW=$(date +%d.%m.%y-%k_%M)
LOGFILE="backup-$NOW.tar"
TARGET=""

# reading backup destination path
read -e -p "Enter .tar destination: [$(tput setaf 6)$CURRENT_DIRECTORY$LOGFILE$(tput sgr 0)] " backup_path
if [ ${#backup_path} -eq 0 ]
then
	# default path
	backup_path="$CURRENT_DIRECTORY"
	if [[ "${CURRENT_DIRECTORY: -1}" != "/" ]]; then
		backup_path="$CURRENT_DIRECTORY/"
	fi
else
	if [[ "${backup_path: -1}" != "/" ]]; then
		backup_path="$backup_path/"
	fi
	if [[ -d "${backup_path}" && ! -L "${backup_path}" ]]; then
    echo "Tar archive target: $backup_path$LOGFILE"
   else
   	backup_path="$CURRENT_DIRECTORY"
   	echo "Wrong choice. Default path: $backup_path"
	fi
fi

# array duplicates checking function
function arrayContains() {
  local array="$1[@]"
  local seeking=$2
  local in=1
  for element in "${!array}"; do
    if [[ $element == $seeking ]]; then
      in=0
      break
    fi
  done
  return $in
}

# files selection
while [ "$FILE" != "" ]; do
	dialog --title "text" --fselect "$CURRENT_DIRECTORY" 60 80
	FILE=$(dialog --stdout --title "Please choose a file" --fselect "$CURRENT_DIRECTORY" 9 60)
	arrayContains BACKUP_PATHS $FILE && : || BACKUP_PATHS+=("$FILE")
	if [ -d "$FILE" ]; then
		DIR="$FILE"
	else
		DIR=$(dirname "${FILE}")
	fi
	CURRENT_DIRECTORY="$DIR"
done

# backup
clear
TARGET="$backup_path$LOGFILE"
echo "[  Date created  ]
$NOW" > "INFO.txt"
echo "[   Files list   ]" >> "INFO.txt"
for i in ${BACKUP_PATHS[@]}; do echo " ~> $i"; done >> "INFO.txt"
cat "INFO.txt"
tar -cf "$TARGET" "INFO.txt"
if [[ ${!BACKUP_PATHS[@]-1} -eq 0 ]]; then
	echo "$(tput setaf 1)No files selected...$(tput sgr 0)"
	exit 1
else
	for i in ${BACKUP_PATHS[@]}; do
		tar --append -P --file=$TARGET $i
	done
	echo "Files dumped to: [$(tput setaf 6) $TARGET $(tput sgr 0)]"
fi
rm "INFO.txt"
echo "Done. Bye!"
