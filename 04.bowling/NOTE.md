# NOTE

## 登場人物

- ボーリングをする人＜Bowler＞

## 用語

- 1ゲーム＜Game＞は10フレーム＜Frame＞
  - 1ゲームの得点＜score＞は最大で300
  - 1フレームの得点は最大で30
- 1フレームは原則2投＜Bowl＞
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
    f-max-bowl-2[/最大投球数は2/]
    f-max-bowl-3[/最大投球数は3/]

    f-new-bowl-start[/Bowlオブジェクトを作成する\]
    f-bowl-num[/投球No/]
    f-bowl-add[Bowlオブジェクトを格納する]
    f-new-bowl-finish[\最大投球数まで繰り返す/]

    f-z((End))

    f-a --> f-initialize --> f-frame-num-judge
    f-frame-num-judge -- Yes --> f-max-bowl-3 --> f-new-bowl-start
    f-frame-num-judge -- No --> f-max-bowl-2 --> f-new-bowl-start
    f-new-bowl-start --> f-bowl-num --> bowl((Bowl)) --> f-bowl-add --> f-new-bowl-finish --> f-z
  end
```

#### Bowl

```mermaid
flowchart LR
  subgraph Bowl
    b-a((Start))
    b-initialize[初期化処理]

    b-bowl-exclude-judge-first-bowl{1投目か}
    b-bowl-exclude-judge-second-bowl{2投目か}
    b-bowl-exclude-judge-third-bowl{3投目か}

    b-bowl-exclude-judge-frame-num{10フレーム目か}
    b-bowl-exclude-judge-first-bowl-is-strike{同フレームの<br>1投目がストライクか}

    b-bowl-exclude-judge-bowl-is-marked{同フレームの<br>1投目がストライクか<br>または<br>2投目がスペアか}

    b-bolw-excluded-false[/有効な投球/]
    b-bolw-excluded-true[/除外される投球/]

    b-z((End))

    b-a --> b-initialize --> b-bowl-exclude-judge-first-bowl -- Yes --> b-bolw-excluded-false
    b-bowl-exclude-judge-first-bowl -- No --> b-bowl-exclude-judge-second-bowl

    b-bowl-exclude-judge-second-bowl -- Yes --> b-bowl-exclude-judge-first-bowl-is-strike
    b-bowl-exclude-judge-second-bowl -- No --> b-bowl-exclude-judge-third-bowl

    b-bowl-exclude-judge-first-bowl-is-strike -- Yes --> b-bowl-exclude-judge-frame-num
    b-bowl-exclude-judge-first-bowl-is-strike -- No --> b-bolw-excluded-false

    b-bowl-exclude-judge-frame-num --Yes --> b-bowl-exclude-judge-bowl-is-marked
    b-bowl-exclude-judge-frame-num --No --> b-bolw-excluded-true

    b-bowl-exclude-judge-bowl-is-marked -- Yes --> b-bolw-excluded-false
    b-bowl-exclude-judge-bowl-is-marked -- No --> b-bolw-excluded-true

    b-bowl-exclude-judge-third-bowl -- Yes --> b-bowl-exclude-judge-frame-num
    b-bowl-exclude-judge-third-bowl -- No --> b-bolw-excluded-true

    b-bolw-excluded-false --> b-z
    b-bolw-excluded-true --> b-z
  end
```

### スコア集計（加算）

#### Frame

```mermaid
flowchart LR
  subgraph Frame
    f-score-judge-first-bowl-is-strike{前フレームの<br>1投目がストライクか}
    f-score-judge-second-bowl-is-spare{前フレームの<br>2投目がスペアか}

    f-a --> f-score-judge-first-bowl-is-strike
    f-score-judge-first-bowl-is-strike -- Yes --> f-increment-score-to-before-frame-p1[前フレームの得点に<br>直近で有効な2投の点を加算する] --> f-z
    f-score-judge-first-bowl-is-strike -- No --> f-score-judge-second-bowl-is-spare

    f-score-judge-second-bowl-is-spare -- Yes --> f-increment-score-to-before-frame-p2[前フレームの得点に<br>直近で有効な1投の点を加算する] --> f-z
    f-score-judge-second-bowl-is-spare -- No --> f-increment-score-to-before-frame-p3[加算なし] --> f-z
  end
```
