#!/bin/bash

MYSQL_HOST=''
MYSQL_USER=''
MYSQL_PASS=''
MYSQL_TABLE=''

SSH_USER=''
SSH_PASS=''
SSH_SERV=''
SSH_PORT=''
SSH_DEST=''

TIMESTAMP=`date "+%Y-%m-%d_%H:%M:%S"`

mysqldump -u$MYSQL_USER -p$MYSQL_PASS -h $MYSQL_HOST $MYSQL_TABLE | gzip -c | sshpass -p $SSH_PASS ssh -p $SSH_PORT -l $SSH_USER $SSH_SERV "cat >> $SSH_DEST/$MYSQL_TABLE-$TIMESTAMP.sql.gz"
