---
title: "[Ruby] ==、equal?、和eql?差在哪裡？"
subtitle: "2分鐘了解它們的區別！"
date: 2020-07-21T23:01:12+08:00
lastmod: 2020-07-24T12:29:00+08:00
author: "Leon Chang"
categories:
- ruby
tags:
- ruby
- equality
isCJKLanguage: true
---

寫程式時無可避免的就是兩個物件或變數是否相等，而Ruby提供一些方法來確認其相等性。

## 比較運算子

比較兩物件是否相等時可以使用**雙等號**（`==`），相等時返回`true`，反之則返回`false`。不等於則使用不等於運算子（`!=`）。通常實作自定義類別時會覆寫這兩個方法。

```ruby
s1 = "apple"
s2 = "apple"
s1 == s2 # => true
s1 != s2 # => false

a1 = ["apple", "banana"]
a2 = ["apple", "banana"]
a1 == a2 # => true
a1 != a2 # => false
```

不同型態的數字也可以使用雙等號。例如：

```ruby
i = 1
f = 1.0
i == f # => true
```

## equal?

**`equal?`方法**比較兩個變數是否參考至同一物件，因此在實作自定義類別時不應覆寫`equal?`方法。

``` ruby
s1 = "apple"
s2 = "apple"
s1.object_id == s2.object_id # => false
s1.equal? s2 # => false

s2 = s1
s1.object_id == s2.object_id # => true
s1.equal? s2 # => true
```

## eql?

**`eql?`方法**比較兩物件的雜湊值（hash value）是否相等。對於`Object`類別的物件而言，`eql?`和`==`是相同的。通常在實作自定義類別時，亦會使`eql?`和`==`的返回值相等以保持這樣的慣例。

`Numeric`類別則是其中的一個例外。

```ruby
1 == 1.0 # => true
1.hash == 1.0.hash # => false
1.eql? 1.0 # => false
```

## 那===呢

`Object#===`與`==`同功能，其子類別會依據需求而覆寫此方法，[下一篇][NextArticle]再詳細說明。

## 參考資料

- [Class_ BasicObject (Ruby 2.6.3)](https://ruby-doc.org/core-2.6.3/BasicObject.html)
- [Difference Between ==, eql_, equal_ in ruby _ by Khalidh Sd _ Medium](https://medium.com/@khalidh64/difference-between-eql-equal-in-ruby-2ffa7f073532)

[NextArticle]: /posts/ruby-triple-equals
