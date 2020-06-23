# check if certificates are in base64 format
import os
from os.path import *

rootDir = join(dirname(abspath(__file__)), '..')
cerDir = join(rootDir, 'cer')

errorFile = []

for cerCategory in os.listdir(cerDir):

    for file in os.listdir(join(cerDir, cerCategory)):
        if not file.endswith('.cer'):
            continue

        with open(join(cerDir, cerCategory, file), 'r') as fr:
            try:
                fr.readline()
            except:
                errorFile.append((cerCategory, file))

if len(errorFile) != 0:
    print('Following files are in binary format')
    print('category', 'filename', sep='\t')
    for category, filename in errorFile:
        print(category, filename, sep='\t')
    exit(1)
