#!/usr/bin/env bash
# author:mapengzhen

:<<!
可以选择的编码如下所示(这些颜色是ANSI标准颜色)：
          编码          颜色/动作
          0      　     重新设置属性到缺省设置
          1     　      设置粗体
          2     　      设置一半亮度(模拟彩色显示器的颜色)
          4     　      设置下划线(模拟彩色显示器的颜色)
          5     　      设置闪烁
          7     　      设置反向图象
          22    　      设置一般密度
          24    　      关闭下划线
          25     　     关闭闪烁
          27     　     关闭反向图象
          30      　    设置黑色前景
          31   　       设置红色前景
          32   　       设置绿色前景
          33   　       设置黄色前景
          34   　       设置蓝色前景
          35    　      设置紫色前景
          36     　     设置青色前景
          37    　      设置白色(灰色)前景
          38      　    在缺省的前景颜色上设置下划线
          39      　    在缺省的前景颜色上关闭下划线
          40      　    设置黑色背景
          41      　    设置红色背景
          42     　     设置绿色背景
          43     　     设置黄色背景
          44     　     设置蓝色背景
          45     　     设置紫色背景
          46     　     设置青色背景
          47      　    设置白色(灰色)背景
          49      　    设置缺省黑色背景
    其他有趣的代码还有：
          \033[2J  　   清除屏幕
          \033[0q  　   关闭所有的键盘指示灯
          \033[1q 　    设置"滚动锁定"指示灯(Scroll Lock)
          \033[2q 　    设置"数值锁定"指示灯(Num Lock)
          \033[3q 　    设置"大写锁定"指示灯(Caps Lock)
          \033[15:40H   把关闭移动到第15行，40列
          \007  　　    发蜂鸣生beep

参数解释:
        t 文本
        F 字体颜色  red yellow blue green black purple white
        B 背景颜色
        b 闪烁
        c 关闭闪烁
        o 关闭属性
!


font_color(){
    color=$1
    case $color in
    red)
        echo -ne "\033[31m"
        ;;
    yellow)
        echo -ne "\033[33m"
        ;;
    blue)
        echo -ne "\033[34m"
        ;;
    green)
        echo -ne "\033[32m"
        ;;
    black)
        echo -ne "\033[30m"
        ;;
    purple)
        echo -ne "\033[35m"
        ;;
    white)
        echo -ne "\033[37m"
        ;;
    *)
        echo "不支持此颜色"
        ;;
    esac
}

bg_color(){
    color=$1
    case $color in
    red)
        echo -ne "\033[41m"
        ;;
    yellow)
        echo -ne "\033[43m"
        ;;
    blue)
        echo -ne "\033[44m"
        ;;
    green)
        echo -ne "\033[42m"
        ;;
    black)
        echo -ne "\033[40m"
        ;;
    purple)
        echo -ne "\033[45m"
        ;;
    white)
        echo -ne "\033[47m"
        ;;
    *)
        echo "不支持此颜色"
        ;;
    esac
}


export opt=$1

while getopts :F:B:obct: ARGS
    do
        case $ARGS in
         o)
            echo -ne "\033[0m"
            ;;
         b)
            echo -ne "\033[5m"
            ;;
         c)
            echo -ne "\033[25m"
            ;;
         F)
            param=$OPTARG
            font_color $param
            ;;
         B)
            param=$OPTARG
            bg_color $param
            ;;
         t)
            param=$OPTARG
            echo -e $param
            ;;
         *)
            echo '''用法:
            t 文本
            F 字体颜色  red yellow blue green black purple white
            B 背景颜色
            b 闪烁
            c 关闭闪烁
            o 关闭属性
            '''
        esac
    done
