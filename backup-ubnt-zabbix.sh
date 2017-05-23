#!/bin/bash

PORTA="22"
USER="admin"
SENHA='mypass'
BKP_PATH=.

SCHEMA='zabbix'
PREFIX='ub-'
SQL="SELECT h.name, i.ip FROM hosts h INNER JOIN interface i ON i.hostid = h.hostid WHERE h.status = 0 AND h.name LIKE '%$PREFIX%'"

mysql "$SCHEMA" -B -N -s -e "$SQL" | while read -r line
do
  NOME=`echo "$line" | cut -f1`
  IP=`echo "$line" | cut -f2`
  sshpass -p "${SENHA}" scp -o "StrictHostKeyChecking no" -P $PORTA $USER@$IP:/tmp/system.cfg "$BKP_PATH/$NOME-`date +%Y-%m-%d`.cfg" &
done
