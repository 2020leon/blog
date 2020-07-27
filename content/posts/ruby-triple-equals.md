---
title: "[Ruby] 「===」和「==」一樣嗎？"
subtitle: "披著等號外皮的多功能運算子"
date: 2020-07-24T12:53:26+08:00
lastmod: 2020-07-24T12:53:26+08:00
author: "Leon Chang"
categories:
- ruby
tags:
- ruby
- operator
isCJKLanguage: true
---

「**三等號**（`===`）」和「雙等號（`==`）」是許多Ruby初學者經常搞混的兩個運算子。一些類別會根據自己的需要而覆寫三等號。本篇會介紹三等號`===`的用法。

## 物件相等性

三等號只有在`Object#===`時與`Object#==`相等。

```ruby
s1 = "apple"
s2 = "apple"
s1 == s2 # => true
s1 === s2 # => true
```

## 型態匹配

`Module`類別覆寫了三等號，使其可以確認物件的型態。例如：

```ruby
3.is_a? Integer # => true
Integer === 3 # => true

"apple".is_a? Integer # => false
Integer === "apple" # => false

Module === Object # => true
Object === Module # => true
```

## 範圍匹配

`Range`類別亦覆寫了三等號，使其可以確認物件是否在範圍內。例如：

```ruby
(0...3).include? 0 # => true
(0...3) === 0 # => true

("a"..."z").include? "z" # => false
("a"..."z") === "z" # => false
```

## 字串匹配

`Regexp`類別也覆寫了三等號，使其可以確認字串是否符合正規表示式（Regular Expression）。例如：

```ruby
/a+/ =~ "apple" # => 0
/a+/ === "apple" # => true
```

## Proc#call

若左手邊是`Proc`類別的物件，則其功能等同於`Proc#call`。例如：

```ruby
cube = Proc.new { |x| x ** 3 }
cube.call 3 # => 27
cube === 3 # => 27
```

## Case Equality Operator

三等號有一個名稱叫「Case Equality Operator」。在`case...when...else`中，`when`便會呼叫`===`來匹配，使程式碼更簡潔。

```ruby
case score
when 0...60
  "failed"
when 60..100
  "passed"
else
  "wrong score"
end
```

## 整理

以下整理各類三等號的等同方法。

| 類       | 方法                     |
|----------|--------------------------|
| `Object` | `#==`, `#eql?`           |
| `Module` | `#is_a?`, `#kind_of?`    |
| `Range`  | `#include?`, `#member?`  |
| `Regexp` | (`#=~`)（不完全相同）    |
| `Proc`   | `#call`, `#yield`, `#[]` |

## 參考資料

- [Class_ Object (Ruby 2.6.3)](https://ruby-doc.org/core-2.6.3/Object.html)
- [Class_ Module (Ruby 2.5.3)](https://ruby-doc.org/core-2.5.3/Module.html)
- [Class_ Range (Ruby 2.7.1)](https://ruby-doc.org/core-2.7.1/Range.html)
- [Class_ Regexp (Ruby 2.7.1)](https://ruby-doc.org/core-2.7.1/Regexp.html)
- [Class_ Proc (Ruby 2.7.1)](https://ruby-doc.org/core-2.7.1/Proc.html)
