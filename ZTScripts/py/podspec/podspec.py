#! /usr/bin/env python
# -*- coding: utf-8 -*-

import os

__author__ = 'mapengzhen'

class Podspec():
	def __init__(self, path):
		self.file_path = path

	def search_version(self):
		search_cmd = './podspec.sh -f %s' % self.file_path
		os.system(search_cmd)

	def change_major_version(self):
		major_cmd = './podspec.sh -M %s' % self.file_path
		os.system(major_cmd)

	def change_minor_version(self):
		minor_cmd = './podspec.sh -m %s' % self.file_path
		os.system(minor_cmd)

	def change_revision_version(self):
		revision_cmd = './podspec.sh -r %s' % self.file_path
		os.system(revision_cmd)

