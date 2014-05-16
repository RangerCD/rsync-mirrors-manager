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
#
#$1=NAME
#$2=SOURCE
#$3=TARGET
#$4=LOG

source $(cd `dirname $0`; pwd)/../sync.conf

if [ $# != 4 ] ; then
	exit 0
fi

SYNC_SUB_LOCK="$VAR_DIR$1".syncing.sub.lock

if [ -e $SYNC_SUB_LOCK ] ; then
        exit 0
else
        touch $SYNC_SUB_LOCK
        chmod 600 $SYNC_SUB_LOCK
fi

trap "rm -f ${SYNC_SUB_LOCK}; exit 0" 0 1 2 3 9 15

echo `date +%Y-%m-%d\ %H:%M:%S` &>> $4
echo "$2" &>> $4
rsync -avH --delete $2 $3 &>> $4
