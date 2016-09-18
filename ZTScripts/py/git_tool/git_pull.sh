#!/usr/bin/env bash
# author:mapengzhen

export THIS_DIR_PATH=$(cd "$(dirname "$0")"; pwd)
export THIS_FILE_NAME=`basename $0`

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
    ${THIS_DIR_PATH}/output_conf.sh -F green -t "-------------------- 更新`basename "$TARGET_DIR"` --------------------" -o

    git status > ${TEMP_FILE}

    enable_update=0
    has_new_file=0
    while read txtLine
    do
        count1=`echo ${txtLine} | grep 'new file:' | wc -l`
        count2=`echo ${txtLine} | grep 'modified:' | wc -l`
        count3=`echo ${txtLine} | grep 'deleted:' | wc -l`
        
        if [[ ${count1} -gt 0 ]]; then
            has_new_file=1
        fi
        
        if [[ ${count1} -gt 0 || ${count2} -gt 0 || ${count3} -gt 0 ]] ;
        then
            enable_update=1
            break
        fi
    done  < ${TEMP_FILE}

    if [[ ${enable_update} -eq 0 ]]; then
        git pull origin master
        ${THIS_DIR_PATH}/output_conf.sh -F green -t "----------------- `basename "$TARGET_DIR"`【更新完成】-----------------" -o
    else
        ${THIS_DIR_PATH}/output_conf.sh -F red
        git status
        ${THIS_DIR_PATH}/output_conf.sh -F purple
        read -p "以上红色部分是未提交记录,输入yes,回车后自动提交;否则退出更新,手动commit（建议手动提交）:" need_update
        ${THIS_DIR_PATH}/output_conf.sh -o
        if [[ $need_update == "yes" ]]; then
            if [[ ${has_new_file} -gt 0 ]]; then
                git add -A
            fi
            git commit -am 'auto commit'
            git pull origin master
            ${THIS_DIR_PATH}/output_conf.sh -F green -t "----------------- `basename "$TARGET_DIR"`【更新完成】-----------------" -o
        else
            ${THIS_DIR_PATH}/output_conf.sh -F red -t "--------------- `basename "$TARGET_DIR"`【有修改未提交】----------------" -o
        fi
    fi

}

cd  ${TARGET_DIR}

#先判断当前是否在 master 分支
if [[ `is_master_branch` -eq 0 ]]; then
    update_master_branch
else
    ${THIS_DIR_PATH}/output_conf.sh -F red -t "-------------- `basename "$TARGET_DIR"`【不在master分支】--------------" -o
fi

rm ${TEMP_FILE}