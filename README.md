rsync-mirrors-manager
===
Sync from multi-sources to localhost via rsync, with one-off simple configuration.

<br>
0. GNU General Public License version 3 (GPLv3)
===
GNU通用公共许可证第三版
>**&lt;rsync-mirrors-manager>**<br>
>**Copyright (C) &lt;2014>  &lt;RangerCD>**
>
>**&lt;rsync-mirrors-manager>**<br>
>**版权所有 (C) &lt;2014>  &lt;RangerCD>**
><br><br>
>This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.<br>
>本程序为自由软件；您可依据自由软件基金会所发表的GNU通用公共授权条款，对本程序再次发布和/或修改；无论您依据的是本授权的第三版，或（您可选的）任一日后发行的版本。
>
>This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.<br>
>本程序是基于使用目的而加以发布，然而不负任何担保责任；亦无对适售性或特定目的适用性所为的默示性担保。详情请参照GNU通用公共授权。
>
>You should have received a copy of the GNU General Public License along with this program.  If not, see &lt;[http://www.gnu.org/licenses/](http://www.gnu.org/licenses/).<br>
>您应已收到附随于本程序的GNU通用公共授权的副本；如果没有，请参照&lt;[http://www.gnu.org/licenses/](http://www.gnu.org/licenses/)>.
>
>Be sure you have backup all important data and try small scale test before put into use.<br>
>确保使用前已备份重要数据并做过小规模测试。

1. Introduction
===
简介
>The target of this program is managing your sync job only with simple configuration.<br>
>本程序的目标是通过简单的设置来管理你的同步工作。
>
>The original motivation of developing is managing my own sync job. My own sync job requires me managing a Linux Mirrors Website, which is synchronizing files from different official Linux distributions' website to my server(named a "mirror").In this case, other people would be able to download the same data from my server in faster speed.<br>
>开发的原始动机是用于管理我自己的同步工作。我的同步工作要求我管理一个Linux的镜像站点，需要从不同的官方Linux发行版站点同步文件到我的服务器（叫做一个“镜像”）。这样，其他人就能从我的服务器上用更快的速度下载到同样的数据。
>
>The problems follow my demand. First of all, the whole server would synchronize about 20 different Linux distributions, each of them has own source and target. Secondly, considering about stability, the backup source is necessary in sync of each distribution which named "multi-sources". Thirdly, the website has to obtain the real time statistics of the server, which means the program has to stat the sync while synchronizing.<br>
>问题随着需求而来。首先，整个服务器会同步大约20个不同的Linux发行版，而每一项都有自己的上游和目标。第二，考虑到稳定性，为每一个发行版同步时的备用上游是必要的，这就是所谓的“多源”。第三，网站必须要获取服务器的实时统计，这也意味着程序必须一边同步一边统计。

2. Configuration
===
配置
>1.Check components
>---
>检查组件
>>All files below should be included in the package. If any component lost, I recommend you download the package from **GitHub** &lt;[https://github.com/RangerCD/rsync-mirrors-manager](https://github.com/RangerCD/rsync-mirrors-manager)>.<br>
>>以下所有文件都应包含在压缩包中。如果有任何组件丢失，我建议您从**GitHub** &lt;[https://github.com/RangerCD/rsync-mirrors-manager](https://github.com/RangerCD/rsync-mirrors-manager)>下载压缩包。
>>
+ **GNU General Public License v3.0 - GNU Project - Free Software Foundation (FSF).htm**
+ **shell\stat.sh**
+ **shell\stat_watcher.sh**
+ **shell\stat_single.sh**
+ **shell\stat_sub.sh**
+ **sync.conf**
+ **sync.sh**

>2.Modify parameters
>---
>修改参数
>>The configure file "sync.conf" defines all parameters. You have to at least glance through the parameters, in order to make sure default value is suitable, any incompatible value should be modify in your own order.<br>
>>配置文件“sync.conf”定义了全部参数。您务必至少浏览这些参数，以保证默认参数值合适，任何不匹配值应当按照您的意愿修改。

>3.Add mirror(s)
>---
>添加镜像
>>Any mirror should be added in configure file "sync.conf". Each mirror should be defined in shell function format. Here is an example:<br>
>>任何镜像都应当在配置文件“sync.conf”中添加。每一个镜像都应按照shell的函数格式定义。以下为一个示例：
>>>example(){<br>
>>>&#160;&#160;&#160;&#160;alias="Example Linux"<br>
>>>&#160;&#160;&#160;&#160;destination=/mirrors/example/<br>
>>>&#160;&#160;&#160;&#160;source=(<br>
>>>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;rsync://test1.test/example/<br>
>>>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;rsync://test2.test/example/<br>
>>>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;)<br>
>>>}<br>
>>
>>**\*parameter "alias" is not in use yet**<br>
>>**\*参数“alias”尚未使用**

3. How to use
===
如何应用
>Basic/基本:
>---
>Once you configured all above correctly, you are able to start sync in simple command below:<br>
>一旦您正确地完成以上配置，您就可以用下面这句简单的命令开始同步：
>>**./sync.sh**
>
>**\*Make sure your current position is where you put this shell**<br>
>**\*确保您当前位置为您放置这个脚本的目录**

>If you want to sync part of your mirrors, you are able to start with this command:<br>
>如果您想要同步部分镜像，您可以通过这句命令实现：
>>**./sync.sh example1 example2 ...**
>
>**\*Make sure your current position is where you put this shell**<br>
>**\*确保您当前位置为您放置这个脚本的目录**
>
>**\*\*"example1 example2 ..."are the function name you added in "sync.conf"**<br>
>**\*\*"example1 example2 ..."是您在“sync.conf”中添加的函数名**

>Options/选项:
>---
>>**--help**
>
>Print the README.md<br>
>打印README.md
><br><br>
>>**--parallel** or **-p**
>
>Sync will be start in parallel mode<br>
>同步将以并行模式开始

4. How to read "sync.log"
===
如何阅读"sync.log"
>The only identifier of each parallel instance is the first number of each line which is followed by date and time.<br>
>每个并行实例的唯一标示符是每行位于日期时间之前的第一个数字。
>
>>**...**<br>
>>[48][2014-05-31-14-11-04][Checking]Prepare to terminate<br>
>>[48][2014-05-31-14-11-14][Terminating]Stopping stat watcher<br>
>>[57][2014-05-31 14:13:33]The result is finished<br>
>>[57][2014-05-31-14-13-33][Finished]Mirror named "example" has been synced<br>
>>**...**<br>
>
>It's obvious that here are two instances of sync, marked with "[48]" and "[57]".<br>
>很明显这里有两个同步实例，以“[48]”与“[57]”标识。

5. Contact information
===
联系方式
>Any problem please contact me.<br>
>任何问题请联系我。
>
>E-mail:compact-disk@live.com<br>
>电子邮件：compact-disk@live.com
>
>**\*I recommend you mark the tittle with "rsync-mirrors-manager feedback"**<br>
>**\*我建议您把标题注明为“rsync-mirrors-manager反馈”**