#!/bin/sh
export opt=$1 
export output=$2
tocolor="\033[0m"
case $opt in
	black)
    tocolor="\033[30m";
    ;;
    red)
    tocolor="\033[31m";
    ;;
    green)
    tocolor="\033[32m";
    ;;
     )
    tocolor="\033[33m";
    ;;
    blue)
    tocolor="\033[34m";
    ;;
    purple)
    tocolor="\033[35m";
    ;;
    cyan)
    tocolor="\033[36m";
    ;;
    reset)
    tocolor="\033[0m";
    ;;
    -h|-help|--help)
    echo "Usage: color_output.sh color message";
    echo "eg:    color_output.sh red message";
    ;;
esac

echo "${tocolor}${output}\033[0m"
