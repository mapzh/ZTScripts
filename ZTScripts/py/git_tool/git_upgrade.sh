#!/usr/bin/env bash
# author:mapengzhen

export THIS_DIR_PATH=$(cd "$(dirname "$0")"; pwd)
export THIS_FILE_NAME=`basename $0`

export TARGET_DIR=$1
export MODEL_NAME=$2
export TARGET_VERSION=$3

cd ${TARGET_DIR}

git commit -am "${TARGET_VERSION}"
git tag ${TARGET_VERSION}
git push origin ${TARGET_VERSION}
git push origin master

#提交podspec文件
cd ../ZTCocoapods/Specs/
mkdir ${MODEL_NAME}
cd ${MODEL_NAME}
mkdir ${TARGET_VERSION}
cd ${TARGET_VERSION}

#将podspec文件拷贝过来
git pull origin master
${THIS_DIR_PATH}/output_conf.sh -F green -t "拷贝${TARGET_DIR}/${MODEL_NAME}.podspec文件到cocoapods目录" -o
cp "${TARGET_DIR}/${MODEL_NAME}.podspec" ${MODEL_NAME}.podspec
git add ${MODEL_NAME}.podspec
git commit -am "add ${MODEL_NAME}[${TARGET_VERSION}]"
git push origin master