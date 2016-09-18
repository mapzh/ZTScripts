#! /usr/bin/env python
# -*- coding: utf-8 -*-

__author__ = 'mapengzhen'

import os
import re
import sys
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
THIS_DIR_PATH = os.path.split(THIS_FILE_PATH)[0]
#脚本所在目录
SCRIPT_PATH = get_parent_dir_path(THIS_DIR_PATH)
#SCRIPT项目所在目录
SCRIPT_PROJECT_PATH = get_parent_dir_path(SCRIPT_PATH)
#主项目所在目录
MAIN_PROJECT_PATH = get_parent_dir_path(SCRIPT_PROJECT_PATH)

def give_x_permission():
    permission_cmd = 'chmod +x %s/%s' % (THIS_DIR_PATH, "*.sh")
    status = os.system(permission_cmd)


def main():
    give_x_permission()
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

    (options, args) = parser.parse_args()


    # if options.clone is not None:
    #     clone(options.clone)


if __name__ == "__main__":
    sys.exit(main())
