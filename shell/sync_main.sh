#!/bin/bash
#
#<rsync-mirrors-manager>
#Copyright (C) <2014>  <RangerCD>
#
#<rsync-mirrors-manager>
#版权所有 (C) <2014>  <RangerCD>
#
#This program is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.
#
#本程序为自由软件；您可依据自由软件基金会所发表的GNU通用公共授权条款，
#对本程序再次发布和/或修改；无论您依据的是本授权的第三版，或（您可选的）
#任一日后发行的版本。
#
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#本程序是基于使用目的而加以发布，然而不负任何担保责任；
#亦无对适售性或特定目的适用性所为的默示性担保。详情请参照GNU通用公共授权。
#
#You should have received a copy of the GNU General Public License
#along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#您应已收到附随于本程序的GNU通用公共授权的副本；如果没有，请参照
#<http://www.gnu.org/licenses/>.
#
#Besure you have backup all important data and try small scale test before put into use.
#确保使用前已备份重要数据并做过小规模测试。

source $(cd `dirname $0`; pwd)/../sync.conf

check_times()
{
	if [ -e "$VAR_DIR"times ] ; then
		TIMES=$((`cat "$VAR_DIR"times`+1))
	else
		TIMES=1
	fi
	echo $TIMES > "$VAR_DIR"times
}

check_log()
{
        while [ $MAX_LOG_FILE -lt `ls -l $LOG_DIR | wc -l` ]
        do
                rm "$LOG_DIR`ls -l $LOG_DIR | sed -n 2p | awk '{print $9}'`"
        done
}

check_times
REAL_TIME=`date +%Y-%m-%d-%H-%M-%S`
echo -e "[\033[33m$TIMES\033[0m][\033[32m$REAL_TIME\033[0m][\033[32mInit\033[0m]Initializing" | tee -a $MAIN_LOG
if [ ! -d "$LOG_DIR" ] ; then
	echo -e "[\033[33m$TIMES\033[0m][\033[32m$REAL_TIME\033[0m][\033[33mInit\033[0m]Making directory \033[31m\"$LOG_DIR\"\033[0m" | tee -a $MAIN_LOG
	mkdir $LOG_DIR
fi
if [ ! -d "$VAR_DIR" ] ; then
	echo -e "[\033[33m$TIMES\033[0m][\033[32m$REAL_TIME\033[0m][\033[33mInit\033[0m]Making directory \033[31m\"$VAR_DIR\"\033[0m" | tee -a $MAIN_LOG
	mkdir $VAR_DIR
fi
if [ ! -d "$TMP_DIR" ] ; then
	echo -e "[\033[33m$TIMES\033[0m][\033[32m$REAL_TIME\033[0m][\033[33mInit\033[0m]Making directory \033[31m\"$TMP_DIR\"\033[0m" | tee -a $MAIN_LOG
	mkdir $TMP_DIR
fi

echo -e "[\033[33m$TIMES\033[0m][\033[32m`date +%Y-%m-%d-%H-%M-%S`\033[0m][\033[32mInit\033[0m]Checking for logs" | tee -a $MAIN_LOG
check_log

echo -e "[\033[33m$TIMES\033[0m][\033[32m`date +%Y-%m-%d-%H-%M-%S`\033[0m][\033[32mInit\033[0m]Obtaining mirror list" | tee -a $MAIN_LOG
NAME_LIST="$TMP_DIR"name."$TIMES".tmp
if [ $# -eq 0 ] ; then
	grep -v "^#\|^$" "$SYNC_ROOT"sync.conf | grep "(){" | awk -F '(' '{print $1}' > $NAME_LIST
else
	echo $* | sed 's/ /\n/g' > $NAME_LIST
fi
COUNT=1
NUM=`cat $NAME_LIST | wc -l`

echo -e "[\033[33m$TIMES\033[0m][\033[32m`date +%Y-%m-%d-%H-%M-%S`\033[0m][\033[32mInit\033[0m]Ready for syncing \033[31m$NUM\033[0m mirror(s)" | tee -a $MAIN_LOG
while [ $COUNT -le $NUM ]
do
	NAME=`sed -n "$COUNT"p $NAME_LIST`
		
	echo -e "[\033[33m$TIMES\033[0m][\033[32m`date +%Y-%m-%d-%H-%M-%S`\033[0m][\033[32mStart\033[0m]Syncing mirror named \033[31m\"$NAME\" $COUNT/$NUM\033[0m" | tee -a $MAIN_LOG
	
	echo -e "[\033[33m$TIMES\033[0m][\033[32m`date +%Y-%m-%d-%H-%M-%S`\033[0m][\033[32mSyncing\033[0m]Logging in \033[31m$LOG_DIR$REAL_TIME.$NAME.log\033[0m" | tee -a $MAIN_LOG
	"$SYNC_ROOT"shell/sync_single.sh $NAME $LOG_DIR$REAL_TIME.$NAME $TIMES
	
	echo -e "[\033[33m$TIMES\033[0m][\033[32m`date +%Y-%m-%d-%H-%M-%S`\033[0m][\033[32mFinished\033[0m]Mirror named \033[31m\"$NAME\"\033[0m has been synced" | tee -a $MAIN_LOG
	COUNT=$(($COUNT+1))
done

echo -e "[\033[33m$TIMES\033[0m][\033[32m`date +%Y-%m-%d-%H-%M-%S`\033[0m][\033[32mChecking\033[0m]Terminating" | tee -a $MAIN_LOG