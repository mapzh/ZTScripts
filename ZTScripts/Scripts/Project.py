#!/usr/bin/python
#coding:utf-8

import os
import re
import sys
import shutil
import logging
from optparse import OptionParser

#gitlab仓库地址
gitlabUrl = 'https://gitlab.com/zt/'

#得到父目录路径
def get_parent_dir_path(path):
    parentPath = os.path.split(path)[0]
    return parentPath

#当前文件目录
thisFilePath = os.path.abspath(__file__)
#父文件目录
thisDirPath = os.path.split(thisFilePath)[0]
#脚本所在目录
scriptPath = get_parent_dir_path(thisDirPath)
#python项目所在目录
pythonProjectPath = get_parent_dir_path(scriptPath)
#Biscuit项目所在目录
biscuitProjectPath = get_parent_dir_path(pythonProjectPath)

def chmodShellFile():
    shArr = ["colour_output.sh","git_clone.sh","git_option.sh","git_pull.sh","git_push.sh","git_reset.sh","git_upgrade_model.sh"]
    for sh in shArr:
        chmodCmd = 'sudo chmod +x %s/%s' % (thisDirPath, sh)


#从源目录copy文件到目的目录
def copy_file(fromPath,toPath):
    copyCmd = 'cp %s %s' % (fromPath,toPath)
    status = os.system(copyCmd)
    return status

def copy_file_with_name(fileName,fromPath,toPath):
    fromPath = os.path.join(fromPath,fileName)
    toPath = os.path.join(toPath,fileName)
    return copy_file(fromPath,toPath)

#把指定依赖库clone到本地
def clone_dependency_to_local(dirName,dependencies):
    for name in dependencies:
        gitUrl = '%s%s.git' % (gitlabUrl,name)
        shPath = os.path.join(thisDirPath,'GirCloneProject.sh')
        print shPath
        cloneCmdTmp = 'sh %s %s %s' % (shPath,dirName,gitUrl)
        cloneStatus = os.system(cloneCmdTmp)
        if cloneStatus!=0:
            print '%s clone failed,status for clone = %s' % (name,cloneStatus)
            sys.exit()

#分析项目依赖,例如：使用正则表达式识别pod 'BiscuitCore', '~> 1.0.0'，找出BiscuitCore
def analyze_dependency(dirName):
    podfilePath = dirName
    podDependency = []
    openPodfile = open(podfilePath , 'r')
    line = openPodfile.readline()
    while line:
        podMatch = re.match('pod \'\S+, \'~>' , line)
        if podMatch:
            dependName = line.split('\'')[1]
            podDependency.append(dependName)
        line = openPodfile.readline()
    openPodfile.close()
    return podDependency

#修改podspec中的版本号，做小版本号+1操作
def modify_podspec_file(podspecFile):
    openTagFile = open(podspecFile,'r')
    tagLine = openTagFile.readline()
    lineTag = 0
    while tagLine:
        tagMatch = re.match('\s*s.version  = \'\d+.\d+.\d+\'\s*',tagLine)
        tagSmallVersionInt = 0
        if tagMatch:
            #以'.'分割字符串，获取最后一段字符串
            splitArr = tagLine.split('.')
            tagSmallVersionString = splitArr.pop()
            #将小版本号之前的字符串保存到newTagString
            newTagString = tagLine[:-len(tagSmallVersionString)]
            #取到最终的小版本号，并+1得到新的小版本号，拼接到newTagString
            tagSmallVersionString = tagSmallVersionString.replace('\'','')
            tagSmallVersionString = tagSmallVersionString.replace(' ','')
            tagSmallVersionInt = int(tagSmallVersionString,10)+1
            newTagString += '%s\'\n' % (str(tagSmallVersionInt))
            #podspec文件读到allLines中，并替换第tagLine行，再将allLines写到文件中
            tmpOpen = open(podspecFile,'r+')
            allLines = tmpOpen.readlines()
            allLines[lineTag] = newTagString
            tmpOpen.close()
            finalOpen = open(podspecFile,'w')
            finalOpen.writelines(allLines)
            finalOpen.close()
            break
        tagLine = openTagFile.readline()
        lineTag = lineTag+1
    openTagFile.close()

#获取podspec最新的版本号
def get_new_tag_version(podspecFile):
    newVersion = ''
    readPodspec = open(podspecFile,'r')
    line = readPodspec.readline()
    while line:
        match = re.search(r'\d+.\d+.\d+',line)
        if match:
            newVersion = match.group()
            break
        line = readPodspec.readline()
    return newVersion

def make_tag(params):
    for modelName in params:
        shPath = os.path.join(thisDirPath,'git_option.sh')
        cmd = 'sh %s -s %s' % (shPath,modelName)
        status = os.system(cmd)
        podspecFilePath = os.path.join(biscuitProjectPath,'%s/%s.podspec' % (modelName,modelName))
        if os.path.exists(podspecFilePath):
            modify_podspec_file(podspecFilePath)
            newVersion = get_new_tag_version(podspecFilePath)
            shPath = os.path.join(thisDirPath,'git_option.sh')
            make_tag_cmd = 'sh %s -t %s,%s' % (shPath,modelName,newVersion)
            os.system(make_tag_cmd)
        else:
            print '没找到对应的podspec'

def pull(params):
    for modelName in params:
        shPath = os.path.join(thisDirPath,'git_option.sh')
        cmd = 'sh %s -l %s' % (shPath,modelName)
        status = os.system(cmd)


def push(params):
    for modelName in params:
        shPath = os.path.join(thisDirPath,'git_option.sh')
        cmd = 'sh %s -s %s' % (shPath,modelName)
        status = os.system(cmd)

def clone(params):
    for modelName in params:
        shPath = os.path.join(thisDirPath,'git_option.sh')
        cmd = 'sh %s -c %s' % (shPath,modelName)
        status = os.system(cmd)

def main():
    chmodShellFile()
    usage = '''
    Example:
        Most common use case:
        > %prog -c BiscuitCore -v.If you want to clone all projects,you can use %prog -c All
        > %prog -l BiscuitCore -v
        > %prog -s BiscuitCore -v
        > %prog -t BiscuitCore -v
    '''
    parser = OptionParser(usage=usage)
    parser.add_option("-v", "--verbose",
                        dest="verbose",
                        help="log",
                        action="store_true")
    parser.add_option("-c", "--clone",
                          dest="clone",
                          help="clone main project and dependencies",
                          action="append")
    parser.add_option("-l", "--pull",
                          dest="pull",
                          help="git pull",
                          action="append")
    parser.add_option("-s", "--push",
                          dest="push",
                          help="git push",
                          action="append")
    parser.add_option("-t", "--tag",
                          dest="make_tag",
                          help="git tag",
                          action="append")
                          
    (options,args) = parser.parse_args()
    #verbose
    if options.verbose ==True:
        logLevel = logging.INFO
    else:
        logLevel = logging.WARNING
    logging.basicConfig(level = logLevel)

    if options.clone is not None:
        clone(options.clone)

    if options.pull is not None:
        pull(options.pull)

    if options.push is not None:
        push(options.push)

    if options.make_tag is not None:
        make_tag(options.make_tag)

if __name__ == "__main__":
    sys.exit(main())
