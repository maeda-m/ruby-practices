# NOTE

## 登場人物

- ボーリングをする人＜Bowler＞

## 用語

- 1ゲーム＜Game＞は10フレーム＜Frame＞
  - 1ゲームの得点＜score＞は最大で300
  - 1フレームの得点は最大で30
- 1フレームは原則2投＜Shot＞
  - 10フレーム目に限り、マーク（ストライクまたはスペアのことで、具体的には下記参照）場合のみ3投できる
    - 1投目がストライクだった場合
    - 2投目がスペアだった場合
- ピン＜pin＞の数は10本
  - 1投目で10本倒したらストライク＜strike＞
    - ストライクの場合は2投目は表記しない
    - ストライクのフレームの得点は次フレームの2投の点を加算する
  - 1投目で全て倒せなかった時、2投目で全て倒したらスペア＜spare＞
    - スペアのフレームの得点は次フレームの1投の点を加算する

## 処理フロー

### 初期化

#### Game

```mermaid
flowchart LR
  subgraph Game
    g-a((Start))
    g-pin-records[/"倒したピンの記録<br>※ストライクの場合は2投目は表記しない"/]

    g-initialize[初期化処理]

    g-new-frame-start[/Frameオブジェクトを作成する\]
    g-frame-num[/フレームNo/]
    g-frame-add[Frameオブジェクトを格納する]
    g-new-frame-finish[\10回繰り返す/]

    g-z((End))

    g-a --> g-pin-records --> g-initialize --> g-new-frame-start --> g-frame-num
    g-frame-num --> frame((Frame)) --> g-frame-add --> g-new-frame-finish --> g-z
  end
```

#### Frame

```mermaid
flowchart LR
  subgraph Frame
    f-a((Start))
    f-initialize[初期化処理]
    f-frame-num-judge{10フレーム目か}
    f-max-shot-2[/最大投球数は2/]
    f-max-shot-3[/最大投球数は3/]

    f-new-shot-start[/Shotオブジェクトを作成する\]
    f-shot-num[/投球No/]
    f-shot-add[Shotオブジェクトを格納する]
    f-new-shot-finish[\最大投球数まで繰り返す/]

    f-z((End))

    f-a --> f-initialize --> f-frame-num-judge
    f-frame-num-judge -- Yes --> f-max-shot-3 --> f-new-shot-start
    f-frame-num-judge -- No --> f-max-shot-2 --> f-new-shot-start
    f-new-shot-start --> f-shot-num --> shot((Shot)) --> f-shot-add --> f-new-shot-finish --> f-z
  end
```

#### Shot

```mermaid
flowchart LR
  subgraph Shot
    b-a((Start))
    b-initialize[初期化処理]

    b-shot-exclude-judge-first-shot{1投目か}
    b-shot-exclude-judge-second-shot{2投目か}
    b-shot-exclude-judge-third-shot{3投目か}

    b-shot-exclude-judge-frame-num{10フレーム目か}
    b-shot-exclude-judge-first-shot-is-strike{同フレームの<br>1投目がストライクか}

    b-shot-exclude-judge-shot-is-marked{同フレームの<br>1投目がストライクか<br>または<br>2投目がスペアか}

    b-bolw-excluded-false[/有効な投球/]
    b-bolw-excluded-true[/除外される投球/]

    b-z((End))

    b-a --> b-initialize --> b-shot-exclude-judge-first-shot -- Yes --> b-bolw-excluded-false
    b-shot-exclude-judge-first-shot -- No --> b-shot-exclude-judge-second-shot

    b-shot-exclude-judge-second-shot -- Yes --> b-shot-exclude-judge-first-shot-is-strike
    b-shot-exclude-judge-second-shot -- No --> b-shot-exclude-judge-third-shot

    b-shot-exclude-judge-first-shot-is-strike -- Yes --> b-shot-exclude-judge-frame-num
    b-shot-exclude-judge-first-shot-is-strike -- No --> b-bolw-excluded-false

    b-shot-exclude-judge-frame-num --Yes --> b-shot-exclude-judge-shot-is-marked
    b-shot-exclude-judge-frame-num --No --> b-bolw-excluded-true

    b-shot-exclude-judge-shot-is-marked -- Yes --> b-bolw-excluded-false
    b-shot-exclude-judge-shot-is-marked -- No --> b-bolw-excluded-true

    b-shot-exclude-judge-third-shot -- Yes --> b-shot-exclude-judge-frame-num
    b-shot-exclude-judge-third-shot -- No --> b-bolw-excluded-true

    b-bolw-excluded-false --> b-z((End))
    b-bolw-excluded-true --> b-z
  end
```

### スコア集計（加算）

#### Frame

```mermaid
flowchart LR
  subgraph Frame
    f-score-judge-first-shot-is-strike{同フレームの<br>1投目がストライクか}
    f-score-judge-second-shot-is-spare{同フレームの<br>2投目がスペアか}

    f-a((Start)) --> f-score-judge-first-shot-is-strike
    f-score-judge-first-shot-is-strike -- Yes --> f-increment-score-to-before-frame-p1[同フレームの得点に<br>次フレーム以降の<br>有効な2投の点を加算する] --> f-z((End))
    f-score-judge-first-shot-is-strike -- No --> f-score-judge-second-shot-is-spare

    f-score-judge-second-shot-is-spare -- Yes --> f-increment-score-to-before-frame-p2[同フレームの得点に<br>次フレーム以降の<br>有効な1投の点を加算する] --> f-z
    f-score-judge-second-shot-is-spare -- No --> f-increment-score-to-before-frame-p3[加算なし] --> f-z
  end
```
