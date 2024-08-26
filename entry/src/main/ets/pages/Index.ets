import router from '@ohos.router';
@Entry
@Component
struct Index {
  @State message: string = 'shabi 毛行轩'

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        Button('打开计算器').width('100%').height(50).fontSize(20).onClick(() => {
          router.pushUrl({
            url: 'pages/calculator',
          });
          console.log("click Button")
        });
      }
      .width('100%')
    }
    .height('100%')
  }
}