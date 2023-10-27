#!/bin/bash

if [ ! -f "$HOME/.config/bscript/bscript.conf" ]; then
  mkdir "$HOME/.config/bscript"
  echo "#<DIRECTORY WHERE BACKUPS WILL BE SAVED (DEFAULTS TO ~/backups)"
  if [ ! -d "$HOME/backups" ]; then
    mkdir "$HOME/backups"
  fi 
  echo "BACKUP_DIRECTORY=~/backups" >> "$HOME/.config/bscript/bscript.conf"
fi

source "$HOME/.config/bscript/bscript.conf"

SOURCES_TO_BACKUP=()

for arg in "$@"; do
  SOURCES_TO_BACKUP+=("$arg")
done

# GET NUM OF BACKUPS

COUNTER=0

for x in "~/backups"; do
  $COUNTER=$($COUNTER+1)
done

function BACKUP_AND_MOVE () {
  local ARCHIVE_NAME=$1
  local BACKUP_NUMBER=0
  local BACKUP_DATE=$(date +'%m_%d_%Y')
  let BACKUP_NUMBER=$COUNTER+1
  local NAME="${ARCHIVE_NAME}_${BACKUP_DATE}#${BACKUP_NUMBER}.tar.xz"

  #-z = gzip
  #-J = xz better than gzip or bzip2 but slower for both compressing and decompressing, but im willing to trade off speed.
  #
  #
  # NOTE THIS WORKS FINE, BUT IM STARTING TO BELIEVE THAT I MAY NEED TO COMPRESS SUBDIRS ASWELL 
  
  tar -cJvf "$NAME" "${SOURCES_TO_BACKUP[@]}"
  mv "$NAME" "$BACKUP_DIRECTORY"
}


while getopts "n:" flag
do
  case $flag in
    n)
      BACKUP_AND_MOVE "$OPTARG"
      # exit the program upon function execution
      exit 0 
    ;;
    *)
      BACKUP_AND_MOVE "data_backup"
      exit 0
  esac
done
