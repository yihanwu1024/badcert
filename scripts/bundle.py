# need openssl installed


def above_eq_py34():
    from pathlib import Path

    parent_dir = Path(os.getcwd()).parent
    certs_dir = parent_dir / 'cer'

    for cert_dir in (_ for _ in certs_dir.iterdir() if _.is_dir()):
        params = []

        for file in (_ for _ in cert_dir.iterdir() if _.name.endswith('.cer')):
            params.append('-certfile')
            params.append(str(file))
        print(params)

        if not params:
            continue

        subprocess.run(
            ['openssl', 'crl2pkcs7', '-nocrl', '-out', str(cert_dir) + '.p7b'] + params,
            cwd=parent_dir)


def below_py34():
    from os.path import join, dirname, abspath

    rootDir = join(dirname(abspath(__file__)), '..')
    cerDir = join(rootDir, 'cer')

    for cerCategory in os.listdir(cerDir):

        params = []

        for file in os.listdir(join(cerDir, cerCategory)):
            if not file.endswith('.cer'):
                continue
            params.append('-certfile')
            params.append(join(cerDir, cerCategory, file))

        print(params)

        if params == []:
            continue

        subprocess.run(
            ['openssl', 'crl2pkcs7', '-nocrl', '-out', join(rootDir, cerCategory + '.p7b')]
            + params, cwd=rootDir)


if __name__ == '__main__':
    import os
    import subprocess
    from sys import version_info

    if version_info >= (3, 4):
        above_eq_py34()
    else:
        below_py34()
