# ボウリングのスコア計算プログラム

## 実行方法

```
$ cd ./ruby-practices
$ ./04.bowling/bowling.rb 1ゲーム分の投球記録
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
$ cd ./ruby-practices
$ ruby ./04.bowling/test_bowling.rb
```

## Linter

```
$ cd ./ruby-practices
$ rubocop
```
