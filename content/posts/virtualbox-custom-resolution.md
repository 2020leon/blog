---
title: "[VirtualBox] 自訂Windows 10解析度"
subtitle: "解決虛擬機解析度問題"
date: 2021-03-06T22:33:49+08:00
lastmod: 2021-03-06T22:33:49+08:00
author: "Leon Chang"
categories:
- virtualbox
tags:
- virtualbox
- resolution
- windows 10
isCJKLanguage: true
---

VirtualBox當Guest OS是Windows 10時解析度預設只提供4:3可以選擇。在此紀錄如何自訂解析度。

## 找到`VBoxManage`執行檔

`VBoxManage`的路徑在不同的Host OS中不盡相同。

### Windows

若在安裝VirtualBox時沒有特別設定，`VBoxManage.exe`會在`C:\Program Files\Oracle\VirtualBox`裡。切換至該資料夾以利稍後的操作。

```dos
cd C:\Program Files\Oracle\VirtualBox
```

### Linux/MacOS

在安裝VirtualBox時會直接在`$PATH`下安裝執行檔。

## 解除解析度限制

```sh
VBoxManage setextradata "YourMachineName" GUI/MaxGuestResolution any
```

將`"YourMachineName"`改成虛擬機的名稱，或是改成`global`（不需引號）解除所有虛擬機的解析度限制。

## 設定解析度

```sh
VBoxManage setextradata "YourMachineName" CustomVideoMode1 "WidthxHeightxBpp"
```

將`"WidthxHeightxBpp"`改成解析度，例如：

```sh
VBoxManage setextradata "Windows 10" CustomVideoMode1 "1440x900x32"
```

bpp為位元每像素（bits per pixel），不知道是什麼的可以參考[這篇][bpp]，大部分的電腦通常是32bbp。

接著再度打開虛擬機，至顯示設定，就可以設定成方才所設定的解析度了。

雖然本篇名為「Windows 10解析度」，但若其他Guest OS遇到無法設定解析度時亦可試試本篇的方法。

## 參考資料

- [How to run a virtual machine in VirtualBox with a custom resolution (3840x2160) | Our Code World](https://ourcodeworld.com/articles/read/1298/how-to-run-a-virtual-machine-in-virtualbox-with-a-custom-resolution-3840x2160)

[bpp]: https://www.imagejoy.com/article/655
