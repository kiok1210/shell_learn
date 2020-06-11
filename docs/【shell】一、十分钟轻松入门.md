
## 一、什么是shell？

### Shell是什么？

1、Shell 是一个程序，Linux默认是用bash。

> Shell 是一个用 C 语言编写的程序，既是一种命令语言，又是一种程序设计语言，是用户使用Linux的桥梁。

> Linux上的Shell有很多种类，如mac上常用zsh， ubuntu用dash，而常用的Linux上则用bash，即Bourne Again Shell（/bin/bash） ， Bourne Shell（/usr/bin/sh或/bin/sh）的扩展版 。

2、shell script是使用shell的脚本。

> 我们通常说的 shell 是指 shell 脚本， 即shell script，是一种为 使用shell 编写的脚本程序。它的文件后缀为.sh，跟.bat、.js、.ptyhon都没有什么本质区别，无非不同环境下的可执行文件。

3、所有脚本无非是命令和流程控制的组合。

> if判断条件，for、while循环，所有程序无出其右。

### Shell编程能做什么？有什么优势？

1、将我们常用的命令固化，将很多步骤做的事合为一个脚本来做。

2、常用来进行我们程序部署时的启动、停止开关。

3、作为一个脚本语言，并且在Linux中有着天然的执行环境，轻量、方便。

### 了解shell对 开发/运维/测试 有什么好处？

1、轻松胜任部署工作；

2、熟悉Linux命令及其工作机制；

3、排查线上问题很方便；

4、扩宽解决问题的思路，拓展解决方案。

## 二、shell的基本语法

我将shell的基本语法分为三块：变量、运算符、条件、循环、函数。

PS.其实任何语言基本都是这几块组成。

### 变量

#### 变量赋值

示例：

    war_name=yao。

注意：

１、变量名和等号之间不能有空格。

２、命名只能使用英文字母，数字和下划线，首个字符不能以数字开头。

３、中间不能有空格，可以使用下划线（_）。

４、不能使用标点符号，如点“.”。

５、不能使用bash里的关键字（可用help命令查看保留关键字）。

#### 变量使用

示例：

    echo ${war_name}
    
    echo $war_name
    
    echo “war name is $war_name”

#### 变量传参

1、$# 传递到脚本的参数个数

2、$1 传递到脚本的第一个参数，1为n

3、$* 所有参数合成一个字符串

4、$@ 所有参数，一个数组

5、$$ 当前脚本运行的进程号,pid

#### 第一个示例脚本

    vi 001.sh
    
    #!/bin/sh
    # author：姚毛毛的博客
    
    echo "Shell 传递参数实例！";
    echo "第一个参数为：$1";
    
    echo "参数个数为：$#";
    echo "传递的参数作为一个字符串显示：$*";

输出结果：
    
    Shell 传递参数实例！
    第一个参数为：1
    参数个数为：5
    传递的参数作为一个字符串显示：1 2 3 4 5

### 运算符 & 算术命令

#### 常用运算符

运算符 | 说明 | 
---|---|
+、- 、* 、/、% | 数值： 加、减、乘、除、余
！、-o、-a、&& 、`||` | 逻辑：非、与、或、and、or
==、!=、<、<= 、> 、>=  | 比较：等于、非等于、小于、小于等于、大于、大于等于
=、+=、-=、*=、/=、&= | 赋值：等于、加等于、减等于、乘等于、除等于、余等于
~、`|`、&、^ | 按位比较： 按位取反、按位异或、按位与、按位或
<< 、 >> | 位运算： 向左移位、向右移位
++、-- | 自增、自减

#### 关系运算符

关系运算符不只支持数字比较，也是支持字符比较的。

关系运算符 | 说明 | 示例
---|---|-- |
-eq | 相等返回true，写法 [$a -eq $b] | [ $a -eq $b ] 返回 true
-ne | 不相等返回true  |   [ $a -ne $b ] 返回 true
-gt | 大于返回true  | [ $a -gt $b ] 返回 false
-lt | 小于返回true  | [ $a -lt $b ] 返回 true
-ge | 大于等于返回true  | [ $a -ge $b ] 返回 false
-le | 小于等于返回true  | [ $a -le $b ] 返回 true

#### 文件测试运算符

运算操作符与运算命令 | 说明
-- | --
-d file  |	检测文件是否是目录，是则返回 	true。 写法 [ -d $file ]
-f file  |	是否是普通文件
-r file  |	是否可读
-w file  |	是否可写
-x file  |	是否可执行
-s file  |	是否为空（文件大小是否大于0）
-e file  |	检测文件（包括目录）是否存在

#### 运算操作符与运算命令

运算操作符与运算命令 | 说明
-- | --
[()] | 整数运算常用，效率高
let | 类似于“[()]”
expr | 手工命令行计数器，一般用于整数值，也可用于字符串
bc | 计算器
$[] | 整数运算
awk | shell命令神器
declare | 可定义变量和属性，-i参数可定义整形变量

### 条件

#### if

    if condition
    then
        command1 
        command2
        ...
        commandN 
    fi

####　if else-if else 

    if condition1
    then
        command1
    elif condition2 
    then 
        command2
    else
        commandN
    fi

### case

    case 值 in
    模式1)
        command1
        ;;
    模式2）
        command1
        ;;
    esac 

### 循环

#### for

    for var in item1 item2 ... itemN
    do
        command1
        command2
        ...
        commandN
    done

#### while

    while condition
    do
        command
    done
    
condition为false,则停止

#### until

    until condition
    do
        command
    done
    
condition为true则停止，一般不用

### 函数

#### function

    [ function ] funname [()]
    
    {
    
        action;
    
        [return int;]
    
    }

#### 示例
    
    #!/bin/bash
    # author:yaomaomao
    
    demoFun(){
        echo "这是我的第一个 shell 函数!"
    }
    echo "-----函数开始执行-----"
    demoFun
    echo "-----函数执行完毕-----“

输出结果：

    -----函数开始执行-----
    这是我的第一个 shell 函数!
    -----函数执行完毕-----


### 特殊符号


符号类型 | 常用符号
---|---
注释符 |#
管道符  |`|`
重定向输入输出  | <、<< ，> 、>>与 0 、1、2
匹配符  | ? 、*
引号  | ’’、””
后台进程符  |&
常运行命令  | nohup

####  符号用法与释义

服务运行命令示例与释义：

    nohup Xxx  > /dev/null 2>&1 &

2>&1 的意思就是将标准错误重定向到标准输出。这里标准输出已经重定向到了 /dev/null。那么标准错误也会输出到/dev/null

nohup 为no hang up，不人为中断会一直运行，一般与&一起用

& 表示后台运行，终端退出则结束进程

测试一下重定向

    ls 2>1 
    
测试一下，不会报没有2文件的错误，但会输出一个空的文件1

    ls xxx 2>1
    
没有xxx这个文件的错误输出到了1中；

    ls xxx 2>&1
    
>与&之间不能有空格，此时可以观察下结果。不会生成1这个文件了，因为错误跑到标准输出了；

    ls xxx > s.log 2>&1 
    # 实际上写全应该是 ls xxx 1> s.log 2>&1
    
重定向符号>默认是1,错误和输出都传到s.log了

### 脚本执行

#### 执行示例

1、相对路径

    ./001.sh

2、绝对路径 

    /root/shell/001.sh

3、不需要脚本执行权限，只需要bash权限 

    sh 001.sh
    bash 001.sh

4、当前shell环境执行 

    source 001.sh 、 . 001.sh

1和2为开启子进程执行脚本，执行完毕，关闭子进程；

3、4则是在当前shell环境下执行，适合被执行程序中有对环境变量的增改，又希望保留到当前shell环境中的情况。

#### 脚本实战

1、批量创建文件、文件夹

2、批量替换文件内容

3、查找大文件并询问删除

4、自动删除过期文件

5、持续输出磁盘、cpu、内存的监控结果

以上题目都是生产中会常用的一些脚本。恩，具体的内容，嘿嘿，下次再说吧。

