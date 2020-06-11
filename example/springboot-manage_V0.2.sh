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