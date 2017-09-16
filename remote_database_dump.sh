#!/bin/bash

# Please, use direct paths to avoid issues
# Modify, depends you want to use passphrase for SSH or key file

MYSQL_HOST=''
MYSQL_USER=''
MYSQL_PASS=''
MYSQL_TABLE=''

SSH_USER=''
SSH_PASS=''
SSH_SERV=''
SSH_PORT=''
SSH_KEY=''

BACKUP_DEST=''

TIMESTAMP=`date "+%Y-%m-%d_%H:%M:%S"`

ssh -p $SSH_PORT -l $SSH_USER $SSH_SERV -i $SSH_KEY "mysqldump -u$MYSQL_USER -p$MYSQL_PASS -h $MYSQL_HOST $MYSQL_TABLE" > $BACKUP_DEST/$MYSQL_TABLE-$TIMESTAMP.sql
