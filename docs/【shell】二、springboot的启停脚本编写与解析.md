
## 零、前言

在做java开发、运维、测试的工作中，跟springboot打交道的地方太多了。

怎么轻松管理一个springboot的项目部署呢？

借着这个来自作者junbaor的优秀实例，我们来看看一个shell脚本是如何炼成的。

### 一、v0.1版本

### 1.1 脚本实例

此版本来自github：https://github.com/junbaor/shell_script/blob/master/spring-boot.sh。

    #!/bin/bash
    
    SpringBoot=$2
    
    if [ "$1" = "" ];
    then
        echo -e "\033[0;31m 未输入操作名 \033[0m  \033[0;34m {start|stop|restart|status} \033[0m"
        exit 1
    fi
    
    if [ "$SpringBoot" = "" ];
    then
        echo -e "\033[0;31m 未输入应用名 \033[0m"
        exit 1
    fi
    
    function start()
    {
    	count=`ps -ef |grep java|grep $SpringBoot|grep -v grep|wc -l`
    	if [ $count != 0 ];then
    		echo "$SpringBoot is running..."
    	else
    		echo "Start $SpringBoot success..."
    		nohup java -jar $SpringBoot > /dev/null 2>&1 &
    	fi
    }
    
    function stop()
    {
    	echo "Stop $SpringBoot"
    	boot_id=`ps -ef |grep java|grep $SpringBoot|grep -v grep|awk '{print $2}'`
    	count=`ps -ef |grep java|grep $SpringBoot|grep -v grep|wc -l`
    
    	if [ $count != 0 ];then
    	    kill $boot_id
        	count=`ps -ef |grep java|grep $SpringBoot|grep -v grep|wc -l`
    
    		boot_id=`ps -ef |grep java|grep $SpringBoot|grep -v grep|awk '{print $2}'`
    		kill -9 $boot_id
    	fi
    }
    
    function restart()
    {
    	stop
    	sleep 2
    	start
    }
    
    function status()
    {
        count=`ps -ef |grep java|grep $SpringBoot|grep -v grep|wc -l`
        if [ $count != 0 ];then
            echo "$SpringBoot is running..."
        else
            echo "$SpringBoot is not running..."
        fi
    }
    
    case $1 in
    	start)
    	start;;
    	stop)
    	stop;;
    	restart)
    	restart;;
    	status)
    	status;;
    	*)
    
    	echo -e "\033[0;31m Usage: \033[0m  \033[0;34m sh  $0  {start|stop|restart|status}  {SpringBootJarName} \033[0m
    \033[0;31m Example: \033[0m
    	  \033[0;33m sh  $0  start esmart-test.jar \033[0m"
    esac

### 1.2 使用示例

启动脚本：

    sh springboot-manage_V0.2.sh start halo.maven-1.3.4.jar 

输出结果：

    Start halo.maven-1.3.4.jar success...
    
报错示例：

    [root@yaomm halo]# sh springboot-manage_V0.2.sh 
     未输入操作名    {start|stop|restart|status} 
    [root@yaomm halo]# sh springboot-manage_V0.2.sh dd 
     未输入应用名 
    [root@yaomm halo]# sh springboot-manage_V0.2.sh dd xx.jar
     Usage:    sh  springboot-manage_V0.2.sh  {start|stop|restart|status}  {SpringBootJarName} 
     Example: 
    	   sh  springboot-manage_V0.2.sh  start esmart-test.jar 

## 二、 v0.1 脚本解析

本实例脚本共分为几部分：

1、输入参数校验；

2、start方法、stop方法、restart方法、status方法

3、根据输入参数，调用启动方法

### 2.1 输入参数校验

#### 2.1.1 代码片段

    SpringBoot=$2
        
    if [ "$1" = "" ];
    then
        echo -e "\033[0;31m 未输入操作名 \033[0m  \033[0;34m {start|stop|restart|status} \033[0m"
        exit 1
    fi
    
    if [ "$SpringBoot" = "" ];
    then
        echo -e "\033[0;31m 未输入应用名 \033[0m"
        exit 1
    fi

注意：中括号（[]）两端至少要有一个空格。

#### 2.1.2 参数解析

1、输入参数个数：2；

2、第一个参数，启停命令：start|stop|restart|status；

3、第二个参数，启动包：xxx.jar

在上一次的文章中（【shell】十分钟轻松入门），第一个示例脚本已经演示过

#### 2.1.3 第一个示例脚本

    vi 001.sh
    
    #!/bin/sh
    # author：姚毛毛
    
    echo "Shell 传递参数实例！";
    echo "第一个参数为：$1";
    
    echo "参数个数为：$#";
    echo "传递的参数作为一个字符串显示：$*";

输出结果：
    
    Shell 传递参数实例！
    第一个参数为：1
    参数个数为：5
    传递的参数作为一个字符串显示：1 2 3 4 5
    
#### 2.1.4 参数校验

    # 将第二个参数赋值给变量SpringBoot
    SpringBoot=$2
        
    #　第一个参数为空，提示“未输入操作”，退出 
    if [ "$1" = "" ];
    then
        echo -e "\033[0;31m 未输入操作名 \033[0m  \033[0;34m {start|stop|restart|status} \033[0m"
        exit 1
    fi
    
    # 第二个参数为空，提示“未输入应用名”，退出
    if [ "$SpringBoot" = "" ];
    then
        echo -e "\033[0;31m 未输入应用名 \033[0m"
        exit 1
    fi

#### 2.1.5 提示文字的解析

在前面的文章《来点有颜色的字符》的一文中，已经说过了，这里复制过来。

    echo -e   "\e[31;43;1m c \e[0m to continue"
    
分析下这串字符串的含义：

1） `\e[31;43;1m`这段代码表示在 "\e["（转义开方括号）和 "m" 之间数值来设置各种效果，不同的数值代表不同的效果，可以多种数字组合起来用，数字之间用分号隔开。

`31;43;1`对应的分别是`字符颜色代码;背景颜色代码;特效代码`，分号分隔。

2）空格一格后写入我们要输出颜色的字符`c`。

3）在字符结尾部分需要加上\e[0m来表示颜色方案结束，否则后面的提示符都会变颜色。

字符串中的`\e`也都可以替换成`\033`，如`echo -e   "\033[31;43;1m c \033[0m to continue"`，效果是一样的。

### 2.2 启停函数 start|stop|restart|status

#### 2.2.1 start 启动

代码片段：

    function start()
    {
    	count=`ps -ef |grep java|grep $SpringBoot|grep -v grep|wc -l`
    	if [ $count != 0 ];then
    		echo "$SpringBoot is running..."
    	else
    		echo "Start $SpringBoot success..."
    		nohup java -jar $SpringBoot > /dev/null 2>&1 &
    	fi
    }

主要脚本：

1、查看进程

    # 查看进程数命令
    count=`ps -ef |grep java|grep $SpringBoot|grep -v grep|wc -l`

主要命令是`ps -ef |grep java|grep $SpringBoot`，只是用wc -l做了个统计。

2、后台不中断启动

这个命令在上篇文章中《【shell】十分钟入门》已经说过。

    nohup java -jar $SpringBoot > /dev/null 2>&1 &
    
java -jar $SpringBoot 这个就不用说了。

2>&1 的意思就是将标准错误重定向到标准输出。这里标准输出已经重定向到了 /dev/null。那么标准错误也会输出到/dev/null

nohup 为no hang up，不人为中断会一直运行，一般与&一起用。

#### 2.2.2 stop 停止

代码片段：

    function stop()
    {
    	echo "Stop $SpringBoot"
    	boot_id=`ps -ef |grep java|grep $SpringBoot|grep -v grep|awk '{print $2}'`
    	count=`ps -ef |grep java|grep $SpringBoot|grep -v grep|wc -l`
    
    	if [ $count != 0 ];then
    	    kill $boot_id
        	count=`ps -ef |grep java|grep $SpringBoot|grep -v grep|wc -l`
    
    		boot_id=`ps -ef |grep java|grep $SpringBoot|grep -v grep|awk '{print $2}'`
    		kill -9 $boot_id
    	fi
    }
    
主要脚本：

1、查找进程id

    # 查找进程id，赋值给boot_id
    boot_id=`ps -ef |grep java|grep $SpringBoot|grep -v grep|awk '{print $2}'`

2、关闭进程

    kill -9 $boot_id

#### 2.2.3 restart

代码片段：

    function restart()
    {
    	stop
    	sleep 2
    	start
    }
    
主要脚本：

1、睡眠2秒
    
    sleep 2

在调用停止方法后，等待2秒，再调用启动脚本，防止启动脚本执行时，进程还未关闭。

#### 2.2.4 status

代码片段：

    function status()
    {
        count=`ps -ef |grep java|grep $SpringBoot|grep -v grep|wc -l`
        if [ $count != 0 ];then
            echo "$SpringBoot is running..."
        else
            echo "$SpringBoot is not running..."
        fi
    }

主要脚本：

1、进程统计

    count=`ps -ef |grep java|grep $SpringBoot|grep -v grep|wc -l`
    
这个之前已经说过，根据jar包名称查找进程，统计其数量。    

### 2.3 case 调用

代码片段：

    case $1 in
    	start)
    	start;;
    	stop)
    	stop;;
    	restart)
    	restart;;
    	status)
    	status;;
    	*)
    
    	echo -e "\033[0;31m Usage: \033[0m  \033[0;34m sh  $0  {start|stop|restart|status}  {SpringBootJarName} \033[0m
    \033[0;31m Example: \033[0m
    	  \033[0;33m sh  $0  start esmart-test.jar \033[0m"
    esac

初看这个脚本可能有点一头雾水，但是看下case的标准语法就会明白了。

case的条件句式：

    case 值 in
        模式1)
            command1
            ;;
        模式2）
            command1
            ;;
    esac 

所以解读下这段脚本，就是只有第一个输入变量是 start|stop|restart|status的时候，才执行对应的方法。

否则，给出提示：

     Usage:    sh  springboot-manage_V0.2.sh  {start|stop|restart|status}  {SpringBootJarName} 
     Example: 
    	   sh  springboot-manage_V0.2.sh  start esmart-test.jar 

## 三、v0.2 脚本实例

对v0.1的脚本进行些许个性化改动。

### 3.1 脚本

    #! /usr/bin/bash
    # 文件名：springboot-manage.sh
    # 描述：springboot启停管理程序
    # version：V0.2
    # 版本说明：0.1版本来自 https://github.com/junbaor/shell_script/blob/master/spring-boot.sh
    # ---------0.2版本添加优雅关闭，及jvm参数如 -Xmx1g -Xms1g -Xss512k,可以自行调整
    # 作者: 姚毛毛
    # Email: kiokyw@163.Com
    # 日期: 2020-06-11
    # 测试环境: Cent OS 7.6
    # 运行方法: springboot start/stop/restart/status xxx.jar
    
    # 第二个参数（$2）为jar，第一个参数为 start|stop|restart|status 这样的操作
    SpringBoot=$2
    
    # 校验第一个参数是否为空，在 [] 内可以直接执行得到变量结果 $1
    #　第一个参数为空，提示“未输入操作”，退出 
    # 注意：中括号[]两端至少要有一个空格
    if [ "$1" = "" ];
    then
        echo -e "\033[0;31m 未输入操作名 \033[0m  \033[0;34m {start|stop|restart|status} \033[0m"
        exit 1
    fi
    
    # 校验第二个参数是否为空
    # 第二个参数为空，提示“未输入应用名”，退出
    if [ "$SpringBoot" = "" ];
    then
    	# `\e[31;43;1m`这段代码表示在 "\e["（转义开方括号）和 "m" 之间数值来设置各种效果，不同的数值代表不同的效果，可以多种数字组合起来用，数字之间用分号隔开。
    	#`31;43;1`对应的分别是`字符颜色代码;背景颜色代码;特效代码`，分号分隔
        echo -e "\033[0;31m 未输入应用名 \033[0m"
        exit 1
    fi
    
    # 启动springboot项目
    function start()
    {
    	count=`ps -ef |grep java|grep $SpringBoot|grep -v grep|wc -l`
    	if [ $count != 0 ];then
    		echo "$SpringBoot is running..."
    	else
    		# 启动springboot项目,反斜杠连接命令
    		nohup java -server -Xmx1g -Xms1g -Xss512k -XX:+AggressiveOpts -XX:+UseBiasedLocking \
    		-XX:+DisableExplicitGC -XX:+UseConcMarkSweepGC \
    		-XX:+UseParNewGC -XX:+CMSParallelRemarkEnabled \
    		-XX:LargePageSizeInBytes=128m -XX:+UseFastAccessorMethods \
    		-XX:+UseCMSInitiatingOccupancyOnly \
    		-jar $SpringBoot > /dev/null 2>&1 &
    		# 问题1：无法在外部设置jvm参数
    		# 问题2：springboot的启动参数过多，会影响输入
    		
    		# 调换提示位置
    		echo "Start $SpringBoot success..."
    	fi
    }
    
    # 关闭springboot项目
    function stop()
    {
    	echo "Stop $SpringBoot ..."
    	
    	# boot_id 获取启动进程号
    	boot_id=`ps -ef |grep java|grep $SpringBoot|grep -v grep|awk '{print $2}'`
    	count=`ps -ef |grep java|grep $SpringBoot|grep -v grep|wc -l`
    
    	# 先用kill -15 发出停止信号，等待springboot自行关闭
    	if [ $count != 0 ];then
    		echo "Stop Success! 优雅关闭 $SpringBoot  Process..."
    		kill -15 $boot_id
    	fi
    	
    	sleep 2
    	
    	# 如果无法优雅关闭，使用kill -9
    	if [ $count != 0 ];then
    		echo "Kill Process! 强制关闭 $SpringBoot  Process..."
    		kill -9 $boot_id
    	else
    		echo "Stop Success! 优雅关闭 $SpringBoot  Process..."
    	fi
    }
    
    # 重启springboot项目，关闭后停止两秒重新启动
    function restart()
    {
    	stop
    	# 睡眠两秒2调用start方法
    	sleep 2
    	start
    }
    
    # 查看springboot项目的启动状态
    function status()
    {
        count=`ps -ef |grep java|grep $SpringBoot|grep -v grep|wc -l`
    	jarStatus=`ps -ef |grep java|grep $SpringBoot`
        if [ $count != 0 ];then
    		# 输出进程状态 执行用户、进程id、运行时间、启动命令等
    		echo "$SpringBoot is running... $jarStatus"
        else
            echo "$SpringBoot is not running..."
        fi
    }
    
    
    # 只有第一个输入变量是 start|stop|restart|status的时候，才执行对应的方法
    #case的条件句式：
    #
    #    case 值 in
    #        模式1)
    #            command1
    #            ;;
    #        模式2）
    #            command1
    #            ;;
    #    esac 
    case $1 in
    	start)
    	start;;
    	stop)
    	stop;;
    	restart)
    	restart;;
    	status)
    	status;;
    	*)
    
    	echo -e "\033[0;31m Usage: \033[0m  \033[0;34m sh  $0  {start|stop|restart|status}  {SpringBootJarName} \033[0m
    \033[0;31m Example: \033[0m
    	  \033[0;33m sh  $0  start esmart-test.jar \033[0m"
    esac

脚本已上传github：https://github.com/kiok1210/shell_learn。

### 3.2 执行示例

    [root@yaomm halo]# sh springboot-manage_V0.2.sh start halo.maven-1.3.4.jar 
    halo.maven-1.3.4.jar is running...

    [root@yaomm halo]# sh springboot-manage_V0.2.sh status halo.maven-1.3.4.jar 
    halo.maven-1.3.4.jar is running... root     14725     1 18 01:34 pts/8    00:00:41 java -server -Xmx1g -Xms1g -Xss512k -XX:+AggressiveOpts -XX:+UseBiasedLocking -XX:+DisableExplicitGC -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -XX:+CMSParallelRemarkEnabled -XX:LargePageSizeInBytes=128m -XX:+UseFastAccessorMethods -XX:+UseCMSInitiatingOccupancyOnly -jar halo.maven-1.3.4.jar

### 3.3 v0.2 版本改动

1、添加了注释；

2、主要改动：

start 添加了jvm参数；

stop 添加了kill -15 命令；

status 输出更多信息。
    
## 四、后记

写这篇文章花了两三个小时，不过感觉自己也收获很多。

如果shell的入门也分境界的话，我想我应该是炼气第二层了。

但是炼气九层，上面还有筑基、金丹、元婴、神游、渡劫、飞升这些境界呢。

总之，继续前行，继续努力吧。

共勉！

