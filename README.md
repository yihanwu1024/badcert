# badcert

用来给我们所唾弃的软件签名的证书集合。
除作者收集的证书以外，还包含了 chinawareblock 和 RevokeChinaCerts 中的一些证书。现有 200+ 个证书。

A collection of certificates that sign unwanted software.
Apart from certificates collected by the author, some certificates from chinawareblock and RevokeChinaCerts are included. Now there are 200+ certificates.

[Telegram 群 Telegram group](https://t.me/badcert)

如果你发现了未被 badcert 收录的坏证书，我们欢迎你开启一个 Pull Request，或将此证书发送到 Telegram 群中。之后它很可能就会被收录。

If you ever find a bad cert that has not been included in badcert, you are welcomed to open a Pull Request or send it to the Telegram group. It is very likely that it will be included in this certificate store.

## 贡献者 Contributors

- yihanwu1024
- Liu233w (Python scripts, CI)

<!--
## [BadcertDeploy Windows 部署工具 (Beta)](https://github.com/yihanwu1024/BadcertDeploy)
此部署工具是一个 Windows 服务，会自动更新 badcert。
## [BadcertDeploy Windows deployment tool (Beta)](https://github.com/yihanwu1024/BadcertDeploy)
This deployment tool is a Windows service that automatically updates badcert.
-->

## Windows 电脑上的手动安装

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

**Effect.** To block any program to be run with administrator privileges, but **not with standard privileges.**

**Coverage of policy.** Policies in "Local Computer" are effective for all users on the computer, while those in "User" are only effective for that user. In common cases, **you need to install these certificates to "Local Computer" to prevent the programs being executed by an administrator**, which is normally what you should expect.
