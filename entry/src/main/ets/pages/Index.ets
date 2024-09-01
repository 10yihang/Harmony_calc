import { router } from '@kit.ArkUI'

@Entry
@Component
struct Index {
    @State expression: string = ''
    @State result: string = ''

    build() {
        Column() {
            Text("操作系统课设")
                .fontSize(40)
                .fontWeight(FontWeight.Bold)
                .textAlign(TextAlign.Center)
                .width('100%')
                .margin({ bottom: 30, top: 30 })

            Button("Calculator")
                .onClick(() => {
                    router.pushUrl({
                        url: 'pages/calculator'
                    })
                })
                .width('80%')
                .height(60)
                .fontSize(20)
                .backgroundColor(Color.Blue)
                .borderRadius(10)
                .margin({ bottom: 20 })
                .alignSelf(ItemAlign.Center)

            Button("Contacts")
                .onClick(() => {
                    router.pushUrl({
                        url: 'pages/Contacts'
                    })
                })
                .width('80%')
                .height(60)
                .fontSize(20)
                .backgroundColor(Color.Green)
                .borderRadius(10)
                .alignSelf(ItemAlign.Center)

        }
        .padding({ left: 20, right: 20 })
        .width('100%')
        .height('100%')
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.SpaceBetween)
    }
}
