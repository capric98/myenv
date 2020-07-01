#!/usr/bin/env python3
#coding=utf-8
import requests
import re

r = requests.get("https://golang.org/dl").text
src_pos = r.find("src.tar.gz")

link = r[src_pos-40:src_pos+10]
link = link[link.find("\"")+1:]

print(re.search("go[0-9].*?src", link).group(0)[2:-4])
