#! /usr/bin/env python
# -*- coding: utf-8 -*-

__author__ = 'mapengzhen'

import os

class GitTool():
    def __init__(self, sp):
        self.source_path = sp

    def git_pull(self):
        pl_cmd = './git_pull.sh %s' % self.source_path
        os.system(pl_cmd)

    def git_push(self):
        ps_cmd = './git_push.sh %s' % self.source_path
        os.system(ps_cmd)

    def git_clone(self, git_url, to_path):

        ps_cmd = './git_clone.sh %s %s' % (git_url, to_path)
        os.system(ps_cmd)




gt = GitTool("/Users/mapengzhen/Desktop/ztp/ZTCore")
gt.git_clone("https://gitlab.com/zt/ZTCore.git", "/Users/mapengzhen/Desktop")