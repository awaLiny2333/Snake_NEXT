@Entry
@Component
struct Index {
  @State board_size: number = 0;
  @State game: boolean[] = [];
  @State head: number = -1;
  @State facing: number = 0;
  // facing 0→ 1↑ 2← 3↓

  @State length_score: number = 1;
  @State now_playing: boolean = false;
  @State snake: number[] = [];
  @State apple: number = 0;
  @State dead: number = 0;

  @State hd_mode: boolean = false;
  @State screen_width: number = 0;
  @State screen_height: number = 0;

  // 0: not start yet; 1: hit wall; 2: hit self

  aboutToAppear(): void {
    this.reset()
    this.apple = -1

    setInterval(() => {
      if (this.now_playing) {
        this.refresh_game()
      }
    }, 500); // Refresh Game
  }

  build() {
    RelativeContainer() {
      Column({ space: 20 }) {

        Grid() {
          ForEach(this.game, (item: boolean, index) => {
            GridItem() {
              Row() {
                // Text(index.toString()) {
                // }
                block({
                  board_size: this.board_size,
                  status: item,
                  index: index,
                  apple: index == this.apple
                })
              }
              .width("100%")
              .height("100%")
            }
            .margin(this.board_size * 2)
          })
        }
        // Grids
        .height(this.board_size * 340)
        .columnsTemplate("1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr")
        .rowsTemplate("1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr")

        Row() {
          Text(this.length_score.toString())
            .opacity(this.board_size == 0? 0 : 1)
            .animation({ duration: 500, delay: 400, curve: Curve.ExtremeDeceleration })

            .fontSize(this.board_size * 50)
            .fontWeight(FontWeight.Bold)
            .layoutWeight(1)
            .textAlign(TextAlign.Start)
            .fontColor($r('app.color.accent'))


          Text(this.get_facing_string())
            .opacity(this.board_size == 0? 0 : 1)
            .animation({ duration: 500, delay: 450, curve: Curve.ExtremeDeceleration })

            .fontSize(this.board_size * 50)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.accent'))
        }
        // Info
      }
      .width(this.board_size * 340)
      .alignRules({
        top: { anchor: '__container__', align: VerticalAlign.Top },
        middle: { anchor: '__container__', align: HorizontalAlign.Center }
      })

        Row() {
          Grid() {
            GridItem()
              .margin(this.board_size * 2)
            GridItem() {
              Button() {
                Text("↑")
                  .textAlign(TextAlign.Center)
                  .fontWeight(FontWeight.Bold)
                  .fontSize(this.board_size * 30)
                  .fontColor($r('app.color.start_window_background'))
                  .backgroundColor($r('app.color.accent'))
                  .borderRadius(this.board_size * 4)
                  .width("100%")
                  .height("100%")
              }
              .margin(this.board_size * 2)
              .backgroundColor("transparent")
              .type(ButtonType.Normal)
              .onClick(() => {
                this.facing = 1
              })
              .clickEffect({level:ClickEffectLevel.LIGHT,scale:0.5})
            }

            GridItem()
              .margin(this.board_size * 2)

            GridItem() {
              Button() {
                Text("←")
                  .textAlign(TextAlign.Center)
                  .fontWeight(FontWeight.Bold)
                  .fontSize(this.board_size * 30)
                  .fontColor($r('app.color.start_window_background'))
                  .backgroundColor($r('app.color.accent'))
                  .borderRadius(this.board_size * 4)
                  .width("100%")
                  .height("100%")
              }
              .margin(this.board_size * 2)
              .backgroundColor("transparent")
              .type(ButtonType.Normal)
              .onClick(() => {
                this.facing = 2
              })
              .clickEffect({level:ClickEffectLevel.LIGHT,scale:0.5})
            }

            GridItem() {
              Button() {
                Text("　")
                  .textAlign(TextAlign.Center)
                  .fontWeight(FontWeight.Bold)
                  .fontSize(this.board_size * 30)
                  .fontColor($r('app.color.start_window_background'))
                  .backgroundColor($r('app.color.accent'))
                  .borderRadius(this.board_size * 4)
                  .width("100%")
                  .height("100%")
              }
              .margin(this.board_size * 2)
              .backgroundColor("transparent")
              .type(ButtonType.Normal)
              .onClick(() => {
                // Speed Up?
              })
              .clickEffect({level:ClickEffectLevel.LIGHT,scale:0.5})
            }

            GridItem() {
              Button() {
                Text("→")
                  .textAlign(TextAlign.Center)
                  .fontWeight(FontWeight.Bold)
                  .fontSize(this.board_size * 30)
                  .fontColor($r('app.color.start_window_background'))
                  .backgroundColor($r('app.color.accent'))
                  .borderRadius(this.board_size * 4)
                  .width("100%")
                  .height("100%")
              }
              .margin(this.board_size * 2)
              .backgroundColor("transparent")
              .type(ButtonType.Normal)
              .onClick(() => {
                this.facing = 0
              })
              .clickEffect({level:ClickEffectLevel.LIGHT,scale:0.5})
            }

            GridItem()
              .margin(this.board_size * 2)
            GridItem() {
              Button() {
                Text("↓")
                  .textAlign(TextAlign.Center)
                  .fontWeight(FontWeight.Bold)
                  .fontSize(this.board_size * 30)
                  .fontColor($r('app.color.start_window_background'))
                  .backgroundColor($r('app.color.accent'))
                  .borderRadius(this.board_size * 4)
                  .width("100%")
                  .height("100%")
              }
              .margin(this.board_size * 2)
              .backgroundColor("transparent")
              .type(ButtonType.Normal)
              .onClick(() => {
                this.facing = 3
              })
              .clickEffect({level:ClickEffectLevel.LIGHT,scale:0.5})
            }

            GridItem()
              .margin(this.board_size * 2)
          }
          // Gamepad
          .opacity(this.board_size == 0? 0 : 1)
          .animation({ duration: 500, delay: 500, curve: Curve.ExtremeDeceleration })

          .width(this.board_size * 150)
          .height(this.board_size * 150)
          .columnsTemplate("1fr 1fr 1fr")
          .rowsTemplate("1fr 1fr 1fr")

          Blank()

          Grid() {
            GridItem()
              .margin(this.board_size * 2)
            GridItem() {
              Button() {
                Text(this.get_start_status())
                  .textAlign(TextAlign.Center)
                  .fontWeight(FontWeight.Bold)
                  .fontSize(this.board_size * 30)
                  .fontColor($r('app.color.start_window_background'))
                  .backgroundColor($r('app.color.accent'))
                  .borderRadius(this.board_size * 4)
                  .width("100%")
                  .height("100%")
              }
              .margin(this.board_size * 2)
              .backgroundColor("transparent")
              .type(ButtonType.Normal)
              .onClick(() => {
                this.reset()
                this.now_playing = true
              })
              .clickEffect({level:ClickEffectLevel.LIGHT,scale:0.7})
            }
            .margin(this.board_size * 2)

            GridItem()
              .margin(this.board_size * 2)

          }
          // Control
          .opacity(this.board_size == 0? 0 : 1)
          .animation({ duration: 500, delay: 550, curve: Curve.ExtremeDeceleration })

          .width(this.board_size * 150)
          .height(this.board_size * 150)
          .rowsTemplate("1fr 1fr 1fr")

        }
        // Buttons
        .width(this.board_size * 340)
        .alignRules({
          bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })

    }
    .backgroundColor($r("app.color.start_window_background"))
    .height('100%')
    .width('100%')
    .onAreaChange((o, n) => {
      this.get_board_size(n.width as number, n.height as number)
    })
    .padding(45)
  }

  get_facing_string() {
    if (this.facing == 0) {
      return "→"
    }
    if (this.facing == 1) {
      return "↑"
    }
    if (this.facing == 2) {
      return "←"
    }
    if (this.facing == 3) {
      return "↓"
    }
    return "?"
  }

  get_start_status() {
    if (this.now_playing) {
      return $r('app.string.Button_Text_Playing')
    } else {
      if (this.dead == 1) {
        return $r('app.string.Button_Text_1')
      }
      if (this.dead == 2) {
        return $r('app.string.Button_Text_2')
      }
      return $r('app.string.Button_Text_0')
    }
  }

  refresh_game() {
    this.move()

    return true
  }

  detect_hit_wall() {
    if (this.facing == 0) {
      if (this.head % 10 == 9) {
        return true
      }
    } // Right
    if (this.facing == 1) {
      if (this.head <= 9) {
        return true
      }
    } // Up
    if (this.facing == 2) {
      if (this.head % 10 == 0) {
        return true
      }
    } // Left
    if (this.facing == 3) {
      if (this.head >= 90) {
        return true
      }
    } // Down
    return false
  }

  detect_hit_self() {
    if (this.snake.includes(this.head)) {
      return true
    }
    return false
  }

  detect_eat_apple() {
    if (this.head == this.apple) {

      return true
    }
    return false
  }

  move() {
    if (this.detect_hit_wall()) {
      this.dead = 1
      this.now_playing = false
      return false
    }

    if (this.facing == 0) {
      this.head += 1
    }
    if (this.facing == 1) {
      this.head += -10
    }
    if (this.facing == 2) {
      this.head += -1
    }
    if (this.facing == 3) {
      this.head += 10
    }

    if (this.detect_hit_self()) {
      this.dead = 2
      this.now_playing = false
      return false
    }

    if (this.detect_eat_apple()) {
      this.apple = Math.floor(Math.random() * 100)
      this.length_score += 1
    } else {
      let tail = this.snake[0]
      this.game[tail] = false
      this.snake.shift()
    }

    this.snake.push(this.head)
    this.game[this.head] = true

    return true
  }

  reset() {
    this.snake = []
    this.game = []
    for (let index = 0; index < 100; index++) {
      this.game.push(false)
    } // Reset Game
    this.facing = 0
    this.head = -1
    this.length_score = 1

    this.apple = Math.floor(Math.random() * 100)
  }

  get_board_size(width: number, height: number) {
    let height_zoom = height / 650
    let width_zoom = width / 400

    this.screen_width = width
    this.screen_height = height

    let board_size = Math.min(height_zoom, width_zoom)
    this.board_size = board_size

    if (this.width > this.height) {
      this.hd_mode = true
    } else {
      this.hd_mode = false
    }

    return board_size
  }
}

@Component
struct block {
  @Prop board_size: number;
  @Prop status: boolean;
  @Prop apple: boolean;
  @Prop index: number;
  @State zoom: string = this.get_init_zoom();

  build() {
    Row() {
    }
    .width(this.zoom)
    .height(this.zoom)
    .animation({ duration: 200, delay: this.index * 3, curve: Curve.ExtremeDeceleration })
    .backgroundColor(
      this.apple ? "#ff813939" :
        this.status ? $r("app.color.accent") : $r("app.color.deep_background")
    )
    .borderRadius(this.board_size * 4)
    .onAreaChange(()=>{
      this.zoom = "100%"
    })
  }

  get_init_zoom() {
    if (this.board_size == 0) {
      return "1%"
    }
    return "100%"
  }
}