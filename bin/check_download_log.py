#!/mnt/ilustre/centos7users/dna/.env/bin/python2 python
'''#!/usr/bin/python'''
# -*- coding:utf-8 -*-

import sys
reload(sys)
sys.setdefaultencoding('utf8')
import argparse
import glob
import subprocess
import time
import os


class Download_working(object):

    def file_2download(self,infile):
        with open(infile,"r")as inf:
            for line in inf:
                urlo = line.strip(" ").strip("\n")
                self.recursive_download(urlo)

    def str_2download(self,instr):
        urlo = instr.strip(" ").strip("\n")
        self.recursive_download(urlo)

    def recursive_download(self,urlo):
        nameo = urlo.split("/")[-1]
        subprocess.call("wget -c "+urlo+" 2>{nameo}.log 1>&2".format(nameo=nameo),shell=True)
        with open(nameo+".log","r")as logf:
            log_info = logf.readlines()
            log_line3 = log_info[-3]
            log_line2 = log_info[-2]
            if "File has already been retrieved" in log_line3 or "The file is already fully retrieved" in log_line2:
                return
            else:
                self.recursive_download(urlo)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="")
    parser.add_argument('--infile', required=False, help='download_file_of_url')
    parser.add_argument('--instr', required=False, help='download_url')
    args = parser.parse_args()
    download_working = Download_working()
    if args.infile:
        download_working.file_2download(args.infile)
    elif args.instr:
        download_working.str_2download(args.instr)
