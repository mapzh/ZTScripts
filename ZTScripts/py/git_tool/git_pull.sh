#!/usr/bin/env bash
# author:mapengzhen

#用于保存屏幕输出
export TEMP_FILE="pull_output.txt"

#$1 目标目录名称
export TARGET_DIR=$1

#用于判断是否为master分支
#@return 0:是 1:不是
is_master_branch()
{
git branch | grep "master" > ${TEMP_FILE}

if [[ `ls -l ${TEMP_FILE} | awk '{print $5}'` -gt 0 ]]; then
    if [[ `cat ${TEMP_FILE}` == "* master" ]]; then
        echo 0
    else
        echo 1
    fi
else
echo 1
fi
}

#@return 0:更新完成 1:更新失败
update_master_branch()
{
./output_conf.sh -F green  -t "..............更新`basename "$TARGET_DIR"`.............."

git status > ${TEMP_FILE}

enable_update=0

while read txtLine
do
count1=`echo ${txtLine} | grep 'new file:' | wc -l`
count2=`echo ${txtLine} | grep 'modified:' | wc -l`
count3=`echo ${txtLine} | grep 'deleted:' | wc -l`

if [[ ${count1} -gt 0 || ${count2} -gt 0 || ${count3} -gt 0 ]] ; then
    enable_update=1
    break
fi
done  < ${TEMP_FILE}

if [[ ${enable_update} -eq 0 ]]; then
    git pull origin master
else
    ./output_conf.sh -F red -t "-------------`basename "$TARGET_DIR"`【有修改未提交】-------------"
fi

}

cd  ${TARGET_DIR}

#先判断当前是否在 master 分支
if [[ `is_master_branch` -eq 0 ]]; then
    update_master_branch
else
    ./output_conf.sh -F red -t "-------------`basename "$TARGET_DIR"`【不在master分支】-------------"
fi

rm ${TEMP_FILE}