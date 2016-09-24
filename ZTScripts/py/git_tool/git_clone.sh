#!/usr/bin/env bash
# author:mapengzhen

export THIS_DIR_PATH=$(cd "$(dirname "$0")"; pwd)
export THIS_FILE_NAME=`basename $0`

export TARGET_DIR=$1


cd ${TARGET_DIR}
${THIS_DIR_PATH}/output_conf.sh -F green -t "-------------------  cloning -------------------" -o
git clone --depth=1 $2
${THIS_DIR_PATH}/output_conf.sh -F green -t "-----------------【clone完成】-----------------" -o
