# need openssl installed

import os
from os.path import *
import subprocess

rootDir = join(dirname(abspath(__file__)), '..')
cerDir = join(rootDir, 'cer')
caDir = join(cerDir, 'ca')
codesigningDir = join(cerDir, 'codesigning')
tlsDir = join(cerDir, 'tls')

params = []

for file in os.listdir(caDir):
    if not file.endswith('.cer'):
        continue
    params.append('-certfile')
    params.append(join(caDir, file))

print(params)

subprocess.run(
    ['openssl', 'crl2pkcs7', '-nocrl', '-out', join(rootDir, 'ca.p7b')]
    + params, cwd=rootDir)

for file in os.listdir(codesigningDir):
    if not file.endswith('.cer'):
        continue
    params.append('-certfile')
    params.append(join(codesigningDir, file))

print(params)

subprocess.run(
    ['openssl', 'crl2pkcs7', '-nocrl', '-out', join(rootDir, 'codesigning.p7b')]
    + params, cwd=rootDir)

for file in os.listdir(tlsDir):
    if not file.endswith('.cer'):
        continue
    params.append('-certfile')
    params.append(join(tlsDir, file))

print(params)

subprocess.run(
    ['openssl', 'crl2pkcs7', '-nocrl', '-out', join(rootDir, 'tls.p7b')]
    + params, cwd=rootDir)
