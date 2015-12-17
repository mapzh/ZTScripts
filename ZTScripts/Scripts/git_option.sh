#!/bin/sh
#MaPengzhen

thisFileDir=`dirname $0`

colour_output(){
    colour=$1
    output=$2
    colorSHPath="${thisFileDir}/colour_output.sh"
    sh ${colorSHPath} ${colour} ${output}
}

get_git_workDir(){
    scriptsDir=`dirname $thisFileDir`
    mainProjectDir=`dirname $scriptsDir`
    proRootDir=`dirname $mainProjectDir`
    if [ ! $1 ] 
    then
        echo ${proRootDir}
    else
        name=$1
        modelDir="${proRootDir}/${name}"
        echo ${modelDir}
    fi
}

switch_git_workDir(){
    dir=`get_git_workDir $1`
    cd ${dir}
}

clone_code(){
    modelName=$OPTARG
    modelGitUrl="https://gitlab.com/zt/${modelName}.git"
    workDir=`get_git_workDir`
    shPath="${thisFileDir}/git_clone.sh"
    sh ${shPath} ${workDir} ${modelGitUrl}
}

pull_code(){
    model_name=$OPTARG
    work_dir=`get_git_workDir $model_name`
    sh_path="${thisFileDir}/git_pull.sh"
    sh ${sh_path} ${work_dir} ${model_name}
}

push_code(){
    modelName=$OPTARG
    workDir=`get_git_workDir $modelName`
    shPath="${thisFileDir}/git_push.sh"
    sh ${shPath} ${workDir} ${modelName}
}

make_tag(){
    param=$OPTARG
    split=$(echo $param|tr "," "\n") 
    model_name=${split[0]}
    new_tag=${split[1]}
    work_dir=`get_git_workDir $model_name`
    sh_path="${thisFileDir}/git_upgrade_model.sh"
    sh ${sh_path} ${work_dir} ${model_name} ${new_tag}
}

while getopts "c:l:s:t:" opt
do
    case $opt in
        c)
        clone_code
        ;;
        l) 
        pull_code
        ;;
        s)
        push_code
        ;;
        t)
        make_tag
        ;;
        ?)
        echo "Usage: 参数范围：c克隆代码 l拉取代码 s上传代码"
    esac
done