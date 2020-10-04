---
title: "[演算法] KMP演算法簡介"
subtitle: "優化的字串搜尋演算法"
date: 2020-10-04T21:34:38+08:00
lastmod: 2020-10-04T21:40:19+08:00
author: "Leon Chang"
categories:
- algorithm
tags:
- algorithm
- string
isCJKLanguage: true
---

字串搜尋經常出現在日常生活中，因此優化後的字串搜尋演算法必然是大家所追求的目標，而**KMP演算法**（Knuth–Morris–Pratt algorithm）便是其中之一。在此整理網路上關於KMP的資料。

## 符號定義

字串搜尋便是在**文字材料**（text）中找到一些**字詞**（pattern）。因此定義`T`代表要搜索的文章（字串），`P`則代表使用者要找的字詞。

本文的所有字串都是由零開始的陣列。若`P = "ALGORITHM"`，則`P[1]`是`L`。`i`和`j`分別代表`T`和`P`的索引。

`P[0 ... j]`表示包含`0`但不包含`j`的字元，在數學上用區間表示即是`[0,j)`。若`P = "ALGORITHM"`，則`P[2 ... 5] = "GOR"`。

## 暴力法

`T`和`P`頭對頭（`i = 0`、`j = 0`），一次取一字一一比對。

- 若`T[i] == P[j]`，則`i++`、`j++`
- 若`T[i] != P[j]`，則`i = i - j + 1`、`j = 0`

時間複雜度**O(mn)**，空間複雜度**O(1)**。

```text
T = ABCDAABCDABD
P = ABCDABD
----------------
1.
T = ABCDAABCDABD
P = ABCDABD
    ^^^^^X

2.
T = ABCDAABCDABD
P =  ABCDABD
     X

3.
T = ABCDAABCDABD
P =   ABCDABD
      X

4.
T = ABCDAABCDABD
P =    ABCDABD
       X

5.
T = ABCDAABCDABD
P =     ABCDABD
        ^X

6.
T = ABCDAABCDABD
P =      ABCDABD
         ^^^^^^#
```

## 改良

暴力法的精神便是逐一比對，但事實上不必如此。觀察上方第二至五步，若能一次性將`P`移動至第五步的位置便能**減少挪動次數**而增加比對效率，尤其`T`為長字串時效果更為顯著。

第一步比對失敗時，`j = 5`。我們發現，可以藉由預先分析`P[0 ... 5] = "ABCDA"`（從`P[0]`到第一步比對失敗**前**的子字串）來決定`P`要挪動多少。

接下來介紹實現此想法所需的前置作業。

### Failure Function

中文簡稱**F函數**，又稱**prefix function**、**border function**。給定一字串，它便會輸出「**次長相同前綴後綴**（longest proper prefix-suffix）」的長度。一個字串可能有不只一個「相同前綴後綴（prefix-suffix）」，而「最長相同前綴後綴」肯定是字串本身；「次長相同前綴後綴」便可顧名思義。

| 字串    | 相同前綴後綴                           | 次長相同前綴後綴 | F函數 |
|---------|----------------------------------------|------------------|-------|
| `ABCDE` | `∅`、`ABCDE`                           | `∅`              | 0     |
| `ABCDA` | `∅`、`A`、`ABCDA`                      | `A`              | 1     |
| `ABCAB` | `∅`、`AB`、`ABCAB`                     | `AB`             | 2     |
| `ABCBA` | `∅`、`A`、`ABCBA`                      | `A`              | 1     |
| `AAAAA` | `∅`、`A`、`AA`、`AAA`、`AAAA`、`AAAAA` | `AAAA`           | 4     |

### 部分匹配表

我們為`P`建立**部分匹配表**（Partial match table）來決定比對失敗時所要挪動的幅度。在此以`P = "ABCDABD"`為例。

| `j`       | 0 | 1 | 2 | 3 | 4 | 5 | 6 |
|-----------|---|---|---|---|---|---|---|
| `P[j]`    | A | B | C | D | A | B | D |
| `next[j]` |   |   |   |   |   |   |   |

當`P[0]`比對失敗後，必須將`P`右移才能繼續比對，因此設`next[j] = -1`。

| `j`       | 0  | 1 | 2 | 3 | 4 | 5 | 6 |
|-----------|----|---|---|---|---|---|---|
| `P[j]`    | A  | B | C | D | A | B | D |
| `next[j]` | -1 |   |   |   |   |   |   |

在`j > 0`的情況下，`next[j] = F(P[0 ... j])`。例如：

- `next[1]` = `F(P[0 ... 1])` = `F("A")` = `len("")` = 0
- `next[5]` = `F(P[0 ... 5])` = `F("ABCDA")` = `len("A")` = 1
- `next[6]` = `F(P[0 ... 6])` = `F("ABCDAB")` = `len("AB")` = 2

| `j`       | 0  | 1 | 2 | 3 | 4 | 5 | 6 |
|-----------|----|---|---|---|---|---|---|
| `P[j]`    | A  | B | C | D | A | B | D |
| `next[j]` | -1 | 0 | 0 | 0 | 0 | 1 | 2 |

其原理便是：當比對失敗時，部分匹配表使你可以直接從`next[j]`開始繼續搜尋而避免「**挪動、比對、失敗**」循環（暴力法第二到四步），便達成減少挪動字數的目的。

接著便利用`next[j]`來搜尋字串：

- 若`T[i] == P[j]`，則`i++`、`j++`
- 若`T[i] != P[j]`，則`j = next[j]`
  - 若`j == -1`，則`i++`、`j++`

時間複雜度**O(m+n)**，空間複雜度**O(n)**。

```text
T = ABCDAABCDABD
P = ABCDABD
----------------
1.
T = ABCDAABCDABD
P = ABCDABD
    ^^^^^X

2.
T = ABCDAABCDABD
P =     ABCDABD
         X

3.
T = ABCDAABCDABD
P =      ABCDABD
         ^^^^^^#
```

此演算法衍生的另一個優點便是，不用每次都從`P[0]`開始比較，因為F函數已經保證移動後「次長相同前綴後綴」的前綴部分和`T`的部分相同，如上方的步驟二。

有文獻稱這種演算法為MP演算法（Morris–Pratt algorithm）。

## KMP演算法

觀察上面的演算法，在第一步遇到不匹配的字元`P`便右移，第二步時`P[1]`又不等於`T[5]`，須再右移一次。為了使演算法更優化，這時便要藉由**優化**`next`來**避免連續挪移**。

再以`P = "ABCDABD"`為例並找出連續挪移的條件。`P[0 ... 5] = "ABCDA"`的「次長相同前綴後綴」為`P[0 ... 1] = P[4 ... 5] = "A"`，若`P[0 .. 1]`和`P[4 ... 5]`的**下一個字元**相同（都是`'B'`），則第一次移動後所比較的字元也會相同（`'A' != 'B'`），因此`P`必須再移動一次。

```text
P          = ABCDABD
P[0 ... 5] = ABCDA
             !*  !*
--------------------
'!' => 次長相同前綴後綴
'*' => 次長相同前綴後綴的下一個字元
```

`newNext`為`next`的優化版，以實現「避免連續挪移」。

| `j`          | 0  | 1 | 2 | 3 | 4 | 5 | 6 |
|--------------|----|---|---|---|---|---|---|
| `P[j]`       | A  | B | C | D | A | B | D |
| `next[j]`    | -1 | 0 | 0 | 0 | 0 | 1 | 2 |
| `newNext[j]` |    |   |   |   |   |   |   |

定義`newNext[0] = -1`，原因見上一節。若`P[0 ... j]`的「次長相同前綴後綴」的前綴和後綴沒有相同的「下一個字元」，則`newNext[j] = next[j]`。

| `j`          | 0  | 1 | 2 | 3 | 4 | 5 | 6 |
|--------------|----|---|---|---|---|---|---|
| `P[j]`       | A  | B | C | D | A | B | D |
| `next[j]`    | -1 | 0 | 0 | 0 | 0 | 1 | 2 |
| `newNext[j]` | -1 | 0 | 0 | 0 |   |   | 2 |

若有相同的下一個字元，則藉遞迴法使其移動時一次到位，即`newNext[j] = newNext[next[j]]`。在本例中：

| `j`                        | 4            | 5            |
|----------------------------|--------------|--------------|
| `P[0 ... j]`               | `ABCD`       | `ABCDA`      |
| 次長相同前綴後綴的**前綴** | `P[0 ... 0]` | `P[0 ... 1]` |
| 次長相同前綴後綴的**後綴** | `P[4 ... 4]` | `P[4 ... 5]` |
| 相同的**下一個字元**       | `A`          | `B`          |
| `newNext[j]`               | -1           | 0            |

> 註：`P[0 ... 4]`的次長前綴後綴為空，但其仍有相同的下一個字元。

將`newNext[j]`填完：

| `j`          | 0  | 1 | 2 | 3 | 4  | 5 | 6 |
|--------------|----|---|---|---|----|---|---|
| `P[j]`       | A  | B | C | D | A  | B | D |
| `next[j]`    | -1 | 0 | 0 | 0 | 0  | 1 | 2 |
| `newNext[j]` | -1 | 0 | 0 | 0 | -1 | 0 | 2 |

接著便利用`newNext[j]`來搜尋字串，規則同上方的改良版：

- 若`T[i] == P[j]`，則`i++`、`j++`
- 若`T[i] != P[j]`，則`j = newNext[j]`
  - 若`j == -1`，則`i++`、`j++`

時間複雜度**O(m+n)**，空間複雜度**O(n)**。

```text
T = ABCDAABCDABD
P = ABCDABD
----------------
1.
T = ABCDAABCDABD
P = ABCDABD
    ^^^^^X

2.
T = ABCDAABCDABD
P =      ABCDABD
         ^^^^^^#
```

## 參考資料

- [Knuth–Morris–Pratt algorithm - Wikipedia](https://en.wikipedia.org/wiki/Knuth%E2%80%93Morris%E2%80%93Pratt_algorithm)
- [演算法筆記 - String Searching](http://web.ntnu.edu.tw/~algo/StringSearching.html)
- [[TIL] 有關字串搜尋的演算法_ KMP](https://www.evanlin.com/about-kmp/)
- [KMP Algorithm for Pattern Searching - GeeksforGeeks](https://www.geeksforgeeks.org/kmp-algorithm-for-pattern-searching/)
