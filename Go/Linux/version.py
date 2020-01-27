#!/usr/bin/env python3
#coding=utf-8
import requests

r = requests.get("https://golang.org/dl").text
src_pos = r.find("src.tar.gz")

link = r[src_pos-40:src_pos+10]
link = link[link.find("\"")+1:]

version_pos = link.find("go/go")+5
print(link[version_pos:link.find("src")-1], end="")
