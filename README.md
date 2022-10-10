# badcert

用来给我们所唾弃的软件签名的证书集合。
除作者收集的证书以外，还包含了 chinawareblock、Malware Patch 和 RevokeChinaCerts 中的一些证书。现有 340+ 个证书。

如果你发现了未被 badcert 收录的坏证书，我们欢迎你开启一个 Pull Request，或将此证书发送到 Telegram 群中。之后它很可能就会被收录。

2022 年 10 月，本项目正在进行改造，故发行版本不可用。

A collection of certificates that sign unwanted software.
In addition to certificates collected by the author, some certificates from chinawareblock, Malware Patch and RevokeChinaCerts are included. Currently there are 340+ certificates.

If you ever find a bad cert that has not been included in badcert, you are welcomed to open a Pull Request or send it to the Telegram group. It is very likely that it will be included in this certificate store.

This project is under extensive change in October 2022, therefore no releases are available.

[Telegram 群 Telegram group](https://t.me/badcert)

## 证书库结构

证书库顶层按照许可的用途分类。

- `ca` 证书颁发机构
- `codesigning` 代码签名

每一项内部都有以**缩减主体字符串**为名的文件夹，每个文件夹中存放对应主体的所有证书。

缩减主体字符串是证书的**主体**字段经过一个确定的修改过程得到的，目的是去除不重要的信息，使得文件名长度不容易超过 255 字节而被截断，并留下可供人类扫视的内容。在当前版本中，它是从主体字段去除 businessCategory 和 serialNumber 后截取前 255 或更少的字节得到的：

```
sed -E -e 's/businessCategory=[0-9a-zA-Z ]+(, )?//' -e 's/serialNumber=[0-9a-zA-Z]+(, )?//' | head -c 255 # or shorter
```

结果如：

```
C=CN, ST=Shanghai, O=Shanghai 2345 Mobile Technology Co., Ltd., OU=IT, CN=Shanghai 2345 Mobile Technology Co., Ltd.
```

所有证书均为 PEM 内的 ASN.1 内的单个 X.509 形式。在主体的文件夹中，证书以`<ISO 8601 生效日期>_<ISO 8601 失效日期>_<指纹>.pem`方式命名，如：

```
2020-04-02_2023-06-12_491FB825246E2DFC1C4DE1E81E0C5AA388ABFBF1.pem
```

## Structure of the Certificate Store

The certificate store is categorized by the allowed purpose on its top level.

- `ca` Certificate authority
- `codesigning` Code signing

Each directory therein is named with a **shortened subject string**, and contains all certificates for the corresponding subject.

The shortened subject string is obtained by processing the certificate **subject** field in a deterministic fashion, intended to remove unimportant information, make the string rarely cropped at 255 bytes, and retain information that is scannable by humans. In the current version, it is constructed by removing businessCategory and serialNumber, then cropping the first 255 or fewer bytes:

```
sed -E -e 's/businessCategory=[0-9a-zA-Z ]+(, )?//' -e 's/serialNumber=[0-9a-zA-Z]+(, )?//' | head -c 255 # or shorter
```

Example result:

```
C=CN, ST=Shanghai, O=Shanghai 2345 Mobile Technology Co., Ltd., OU=IT, CN=Shanghai 2345 Mobile Technology Co., Ltd.
```

Every certificate is in the form of a single X.509 inside ASN.1 inside PEM. In the subject directory, certificates are named in the form of `<ISO 8601 Not Before Date>_<ISO 8601 Not After Date>_<Fingerprint>.pem`. For example:

```
2020-04-02_2023-06-12_491FB825246E2DFC1C4DE1E81E0C5AA388ABFBF1.pem
```

<!--## Windows 电脑上的手动安装

1. 下载 `.p7b`。
1. 运行 `mmc` 或 `certmgr.msc`。（如果想要管理“本地计算机”的证书，则需要以管理员身份运行。）
1. (如果运行了 `mmc`) 添加控制台的证书管理单元。
1. 转到“不信任的证书 → 证书”，右键空白处，在上下文菜单中选择“所有任务” → “导入”。
1. 选择 `.p7b`。

此时，你应该可以看到列表中出现了证书。

**效果。** 阻止程序以管理员权限运行，而**不阻止以标准权限运行。**

**政策的有效范围。** “本地计算机”中的政策对这台电脑上的所有用户都有效，而“用户”中的政策只对这个用户有效。在一般情况下，**你需要将证书安装到“本地计算机”中，才能阻止以管理员身份运行的程序**——你应该就想要这种效果。

## Manual installation on a Windows computer

1. Download `.p7b`.
1. Run `mmc` or `certmgr.msc`. (If you'd like to manage certificates in "Local Computer", you need to run as administrator.)
1. (If you ran `mmc`) add the Certificate Management snap-in to the console.
1. Navigate to "Untrusted Certificates → Certificates", right-click on the blank space, and choose "All Tasks" → "Import" in the context menu.
1. Choose `.p7b`.

You should see certificates in the list now. 

**Effect.** To block any program from running with administrator privileges, but **not with standard privileges.**

**Coverage of policy.** Policies in "Local Computer" are effective for all users on the computer, while those in "User" are only effective for that user. In common cases, **you need to install these certificates to "Local Computer" to prevent the programs being executed by an administrator**, which is normally what you should expect.-->
