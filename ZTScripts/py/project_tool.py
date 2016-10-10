#! /usr/bin/env python
# -*- coding: utf-8 -*-

__author__ = 'mapengzhen'

'''
版本号(GUN风格):
主版本号.子版本号[.修正版本号[.编译版本号]]

Major_Version_Number.Minor_Version_Number[.Revision_Number[.Build_Number]]

示例：1.2.1 、 2.0 、 5.0.0 build-13124

'''

from podspec import podspec
import sys
import os
import shutil
import logging
from optparse import OptionParser

#gitlab仓库地址
GIT_BASE_URL = 'https://gitlab.com/zt/'

#得到父目录路径
def get_parent_dir_path(path):
    parentPath = os.path.split(path)[0]
    return parentPath

#当前文件目录
THIS_FILE_PATH = os.path.abspath(__file__)
#父文件目录
THIS_DIR_PATH = os.path.dirname(THIS_FILE_PATH)
#脚本所在目录
SCRIPT_PATH = get_parent_dir_path(THIS_DIR_PATH)
#SCRIPT项目所在目录
SCRIPT_PROJECT_PATH = get_parent_dir_path(SCRIPT_PATH)
#主项目所在目录
MAIN_PROJECT_PATH = get_parent_dir_path(SCRIPT_PROJECT_PATH)



def change_minor_version():
    print "change_minor_version"

def change_major_version():
    print "change_major_version"

def change_revision_version():
    print "change_revision_version"


def main():
    usage = '''
    Example:
        Most common use case:
        > %prog -v
        > %prog -m model_name
        > %prog -M model_name
        > %prog -r model_name
    '''
    parser = OptionParser(usage=usage)
    parser.add_option("-v", "--verbose",
                      dest="verbose",
                      help="log",
                      action="store_true")
    parser.add_option("-m", "--minor",
                      dest="change_minor_version",
                      help="修改子版本号",
                      action="append")
    parser.add_option("-M", "--major",
                      dest="change_major_version",
                      help="修改主版本号",
                      action="append")
    parser.add_option("-r", "--revision",
                      dest="change_revision_version",
                      help="修改修正版本号",
                      action="append")

    (options, args) = parser.parse_args()


if __name__ == "__main__":
    sys.exit(main())

