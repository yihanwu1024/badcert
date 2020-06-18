# need openssl installed

import os
from os.path import *
import subprocess

rootDir = join(dirname(abspath(__file__)), '..')
cerDir = join(rootDir, 'cer')

params = []

for file in os.listdir(cerDir):
    if not file.endswith('.cer'):
        continue
    params.append('-certfile')
    params.append(join(cerDir, file))

print(params)

subprocess.run(
    ['openssl', 'crl2pkcs7', '-nocrl', '-out', join(rootDir, 'badcerts.p7b')]
    + params, cwd=rootDir)
