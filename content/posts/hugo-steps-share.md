---
title: "[Hugo] 架站步驟分享"
subtitle: "少許步驟輕鬆上手"
date: 2020-08-02T00:48:31+08:00
lastmod: 2020-08-02T00:48:31+08:00
author: "Leon Chang"
categories:
- hugo
tags:
- hugo
- blog
- site
isCJKLanguage: true
---

利用Hugo架網站其實不難（MacOS），只是若想要讓網站成為自己心目中的版面還要多花一些功夫就是了。Hugo官網上也有[簡單的教學][HugoQuickStart]，讓使用者可以快速架設Hugo網站。

Windows作業系統可以參考[這篇][WindowsHugo]。

## Hugo簡介

Hugo是由Go寫成的靜態網頁產生器（static site generator），網站主要內容以Markdown格式撰寫，經Hugo編譯成HTML後可供瀏覽器瀏覽，其最大的優點為建置速度相較於其他靜態網頁產生器（如Jekyll）快上許多，另外便是其英文教學文檔還算清楚。

## 安裝Hugo

在MacOS或Linux環境下安裝相對簡單。

```sh
brew install hugo
```

不知道什麼是`brew`的人可以參考Homebrew的[官網][Brew]。

安裝後確認是否安裝成功：

```sh
$ hugo version
Hugo Static Site Generator v0.74.3/extended darwin/amd64 BuildDate: unknown
```

版本號可能會不一樣，只要不要輸出錯誤訊息就好了。

## 建立新網站

```sh
hugo new site my_site
```

`my_site`是專案資料夾的名稱，可以自己決定。

## 加入主題

Hugo沒有預設主題，必須要加入主題才能使網站運作。Hugo蒐集了許多的[主題][HugoThemes]（theme），可以選擇自己喜歡的主題下載。這邊以Axiom為例。

```sh
cd my_site
git init
git submodule add https://github.com/marketempower/axiom.git themes/axiom
```

如果不想用`git`的話，也可以直接去GitHub下載整個專案，並放置在`themes`資料夾中。

如果想要以某個主題為基礎來創建新主題，也可以直接下載或以`git clone`、`git subtree`的方式處理。官方的建議是用`git submodule`。

如果確定要用該主題，可以在配置檔`config.toml`加入`theme = "axiom"`：

```sh
echo 'theme = "axiom"' >> config.toml
```

或著可以在[預覽](#預覽)階段指定主題。

通常每個主題都會附上範例網頁，部分主題還會有說明文檔，可以各主題的範例網頁做為選擇的參考。

## 新增頁面

```sh
hugo new posts/my-first-post.md
```

Hugo會在`content`資料夾下建立`posts/my-first-post.md`，打開後會發現裡面有關於頁面建立時間的資訊，可以在其下方隨意加入一些內容。

## 預覽

開啟Hugo server便可預覽目前的成果：

```sh
hugo server -D
```

`-D`表示預覽所有非草稿及草稿（標註`draft = true`）頁面。如果沒在`config.toml`加入`theme = "axiom"`，可以在開啟server時指定主題：

```sh
hugo server -t axiom
```

接著在任何瀏覽器輸入<http://localhost:1313/>以預覽網站；在終端機按`Ctrl+C`便可關閉server。

在預覽過程中可能會發現和主題作者所提供的範例頁面有所出入（某部分無法順利顯示等），這便要視各主題有沒有要求任何必要變數使模板順利運作。如果原作者有提供說明文檔或範例頁面的原始碼，就可以藉此推敲出其中的端倪。

## 建立靜態網頁

在所有設定（配置檔內容、草稿與否等）都配置好的情況下便可直接執行以下指令：

```sh
hugo
```

Hugo會建立`public`目錄，其內容包括靜態網頁所需的HTML、CSS、JS檔。`hugo`指令亦可藉flags（`-D`、`-t`等）輔助配置。

## 參考資料

- [Quick Start _ Hugo][HugoQuickStart]
- [透過Hugo快速建置個人Blog - Carson's Tech Note](https://carsonwah.github.io/15213187969126.html)

[HugoQuickStart]: https://gohugo.io/getting-started/quick-start/
[WindowsHugo]: https://blog.yowko.com/windows-10-hugo/
[Brew]: https://brew.sh/
[HugoThemes]: https://themes.gohugo.io/
