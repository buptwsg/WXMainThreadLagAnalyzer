#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import sys
import time
import shutil
import commands
from stat import *

def dsymFilePath():
	dsymPath = os.environ["BUILT_PRODUCTS_DIR"] + "/" + os.environ["PRODUCT_NAME"] + ".app.dSYM"
	print 'dsymPath: ' + dsymPath
	return dsymPath

def workDir():
	currentDir = os.path.expanduser("~/Downloads/symbolicatetool") #os.path.dirname(os.path.realpath(__file__))
	print "workDir: " + currentDir
	return currentDir

def createDSymFile():
	execName = os.environ["EXECUTABLE_NAME"]
	execPath = os.environ["BUILT_PRODUCTS_DIR"] + "/" + os.environ["PRODUCT_NAME"] + ".app" + "/" + execName
	outPath = os.environ["BUILT_PRODUCTS_DIR"] + "/" + os.environ["PRODUCT_NAME"] + ".dSYM"
	cmdStr = "xcrun dsymutil " + execPath + " -o " + outPath + " 2> /dev/null"
	print "dsymutil cmdStr: " + cmdStr
	s, ret = commands.getstatusoutput(cmdStr)
	print "cmdStr ret: " + str(s)
	return outPath

def deleteDSymFile():
	destDir = workDir() + "/build"
	
	if not os.path.exists(destDir):
		print "no destDir: " + destDir
		return

	files = []
	for f in os.listdir(destDir):
		if f.endswith(".dSYM"):
			path = destDir + "/" + f
			files.append(path)
	print "files: ", files

	for f in files:
		if not os.path.exists(f):
			continue
		shutil.rmtree(f)

def copyDSymFile():
	isGen = False
	srcPath = dsymFilePath()
	if not os.path.exists(srcPath):
		isGen = True
		srcPath = createDSymFile()

	if not os.path.exists(srcPath):
		print "source dSYM not found: " + srcPath
		return
	else:
		print "source dSYM found: " + srcPath

	destDir = workDir() + "/build"
	execName = os.environ["EXECUTABLE_NAME"]
	destPath = destDir + "/" + execName + ".app" + ".dSYM"
	print "destPath: " + destPath
	if os.path.exists(destPath):
		print "destPath alread exists"
	else:
		shutil.copytree(srcPath, destPath)

	if isGen:
		shutil.rmtree(srcPath)

def canRun():
	if os.environ["EFFECTIVE_PLATFORM_NAME"] == "-iphonesimulator":
		print "is iphonesimulator build, just return"
		return False
	return True

if __name__ == '__main__':
	print "createdsym.py main start"
	if canRun():
		print "can run"
		try:
			deleteDSymFile()
			copyDSymFile()
		except Exception, err:
			print "warning: unhandled exception:"
			print Exception, err
	else:
		print "cannot run"
	print "createdsym.py main end"
