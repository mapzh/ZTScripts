#!/bin/sh

export TARGET_DIR=$1

colour_output(){
    colour=$1
    output=$2
    thisFileDir=`dirname $0`
    colorSHPath="${thisFileDir}/colour_output.sh"
    sh ${colorSHPath} ${colour} ${output}
}

cd ${TARGET_DIR}
colour_output green "..............克隆`basename "$2"`.............."
git clone --depth=1 $2
