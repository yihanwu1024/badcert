# need openssl installed

import os
from os.path import *
import subprocess

rootDir = join(dirname(abspath(__file__)), '..')
cerDir = join(rootDir, 'cer')

for cerCategory in os.listdir(cerDir):

    params = []

    for file in os.listdir(join(cerDir, cerCategory)):
        if not file.endswith('.cer'):
            continue
        params.append('-certfile')
        params.append(join(cerCategory, file))

    print(params)

    if params == []:
        continue

    subprocess.run(
        ['openssl', 'crl2pkcs7', '-nocrl', '-out', join(rootDir, cerCategory + '.p7b')]
        + params, cwd=rootDir)
