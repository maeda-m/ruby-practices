# ボウリングのスコア計算プログラムオブジェクト指向版

## 実行方法

```
$ cd ./ruby-practices/07.bowling_object/
$ ./bowling.rb 1ゲーム分の投球記録
```

### 1ゲーム分の投球記録について

e.g. `6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5`

|表記  |意味        |
|:-----|:-----------|
|`,`   |投球の区切り|
|`0-10`|何本倒したか|
|`X`   |ストライク  |

## テスト方法

```
$ cd ./ruby-practices/07.bowling_object/
$ ruby ./test/test_bowling.rb
```

## Linter

```
$ cd ./ruby-practices/07.bowling_object/
$ rubocop
```
