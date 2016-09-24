#! /usr/bin/env python
# -*- coding: utf-8 -*-

__author__ = 'mapengzhen'

import os

class GitTool():
    def __init__(self, sp):
        self.source_path = sp
        self.__give_x_permission("./*.sh")


    def __give_x_permission(self, path):
        this_path = os.path.abspath(__file__)
        this_dir = os.path.dirname(this_path)
        cd_cmd = 'cd %s' % this_dir
        os.system(cd_cmd)
        chmod_cmd = 'chmod +x %s' % path
        os.system(chmod_cmd)


    def git_pull(self):
        pl_cmd = './git_pull.sh %s' % self.source_path
        os.system(pl_cmd)

    def git_push(self):
        ps_cmd = './git_push.sh %s' % self.source_path
        os.system(ps_cmd)

    def git_clone(self, git_url, to_path):
        ps_cmd = './git_clone.sh %s %s' % (git_url, to_path)
        os.system(ps_cmd)
