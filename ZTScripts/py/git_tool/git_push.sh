#!/usr/bin/env bash
# author:mapengzhen

export this_dir_path=$(cd "$(dirname "$0")"; pwd)
export this_file_name=`basename $0`

#用于保存屏幕输出
export TEMP_FILE="push_output.txt"
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
push_master_branch()
{
    ${this_dir_path}/output_conf.sh -F green -t "-------------------- 上传`basename "$TARGET_DIR"` --------------------" -o

    git status > ${TEMP_FILE}

    enable_push=1
    has_new_file=0
    while read txtLine
    do
        count1=`echo ${txtLine} | grep 'new file:' | wc -l`
        count2=`echo ${txtLine} | grep 'modified:' | wc -l`
        count3=`echo ${txtLine} | grep 'deleted:' | wc -l`

        if [[ ${count1} -gt 0 ]]; then
            has_new_file=1
        fi

        if [[ ${count1} -gt 0 || ${count2} -gt 0 || ${count3} -gt 0 ]] ; then
            enable_push=0
            break
        fi
    done  < ${TEMP_FILE}

    rm ${TEMP_FILE}

    if [[ ${enable_push} -eq 1 ]]; then
        git pull origin master
        git push origin master
    else

        ${this_dir_path}/output_conf.sh -F red
        git status
        ${this_dir_path}/output_conf.sh -F purple
        read -p "以上红色部分是未提交记录,输入yes,回车后自动提交;否则退出更新,手动commit（建议手动提交）:" need_update
        ${this_dir_path}/output_conf.sh -o
        if [[ $need_update == "yes" ]]; then
            if [[ ${has_new_file} -gt 0 ]]; then
                git add -A
            fi
            git commit -am 'auto commit'
            git pull origin master
            git push origin master
            ${this_dir_path}/output_conf.sh -F green -t "----------------- `basename "$TARGET_DIR"`【上传完成】-----------------" -o
        else
            ${this_dir_path}/output_conf.sh -F red -t "----------------- `basename "$TARGET_DIR"`【上传失败】-----------------" -o
        fi

    fi

}

cd  ${TARGET_DIR}

#先判断当前是否在 master 分支
if [[ `is_master_branch` -eq 0 ]]; then
    push_master_branch
else
    ${this_dir_path}/output_conf.sh -F red -t "-------------- `basename "$TARGET_DIR"`【不在master分支】--------------" -o
fi
