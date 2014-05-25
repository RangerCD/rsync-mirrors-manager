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

STAT_LOCK="$VAR_DIR"stating.lock

if [ -e $STAT_LOCK ] ; then
        exit 0
else
        touch $STAT_LOCK
        chmod 600 $STAT_LOCK
fi

trap "rm -f ${STAT_LOCK}; exit 0" 0 1 2 3 9 15

STAT_FILE="$VAR_DIR"stat
LAST_STAT="$TMP_DIR"stat.last.tmp
STAT_BUFFER="$TMP_DIR"stat.tmp

if [ ! -f $STAT_FILE ] ; then
        touch $STAT_FILE
fi
cp $STAT_FILE $LAST_STAT

> $STAT_BUFFER
NAME_LIST="$TMP_DIR"name.tmp
grep -v "^#\|^$" "$SYNC_ROOT"sync.conf | grep "(){" | awk -F '(' '{print $1}' > $NAME_LIST
NUM=`cat $NAME_LIST | wc -l`
COUNT=1
while [ $COUNT -le $NUM ]
do
        NAME=`sed -n "$COUNT"p $NAME_LIST`
	LOG_FILE=$LOG_DIR`ls -l $LOG_DIR | grep "\.$NAME\." | tail -1 | awk '{print $9}'`
	if [ "$LOG_FILE" == "$LOG_DIR" ] ; then
                COUNT=`expr $COUNT + 1`
                continue
        fi
	SOURCE=`sed -n 2p $LOG_FILE`
        START_TIME=`head -1 $LOG_FILE`
        END_TIME=`stat -c %y $LOG_FILE | awk -F '.' '{print $1}'`
        TAIL=`tail -1 $LOG_FILE`
        SYNC_LOCK="$VAR_DIR""$NAME".syncing.sub.lock
	if [ "`echo $TAIL | grep "total size"`" != "" ] ; then
                STATUS=finished
                SIZE=`echo $TAIL | awk '{print $4}'`
        elif [ "`echo $TAIL | grep "rsync error"`" != "" ] ; then
                STATUS=error
                SIZE=`cat $LAST_STAT | grep "^$NAME\|" | awk -F '|' '{print $2}'`
        elif [ -e $SYNC_LOCK ] ; then
                STATUS=syncing
                SIZE=`cat $LAST_STAT | grep "^$NAME\|" | awk -F '|' '{print $2}'`
        else
                STATUS=error
                SIZE=`cat $LAST_STAT | grep "^$NAME\|" | awk -F '|' '{print $2}'`
        fi
        echo "$NAME|$SIZE|$SOURCE|$START_TIME|$END_TIME|$STATUS" &>> $STAT_BUFFER
        COUNT=`expr $COUNT + 1`
done

cp $STAT_BUFFER $STAT_FILE
