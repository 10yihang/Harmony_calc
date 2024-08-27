import router from '@ohos.router';
import { Context, featureAbility } from '@kit.AbilityKit';
import { MyRdb, Info} from '../ContactDB';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct ContactsPage {
    @State contactList: Array<Info> = new Array();
    @State contact: Info = new Info(0, '', '');
    @State index: number = 0
    @State context: Context = getContext();
    @State isListReachEnd: boolean = false;

    aboutToAppear() {
        this.initializeAndLoadData();
    }

    async initializeAndLoadData() {
        await MyRdb.getInstance().initRdbStore(this.context);
        await MyRdb.getInstance().insertUser(this.context, 'John Doe', '1234567890')
        await MyRdb.getInstance().insertUser(this.context, 'Jane Smith', '9876543210')
        await MyRdb.getInstance().insertUser(this.context, 'Mike Brown', '5555555555')
        await this.loadContacts();
    }

    loadContacts() {
        MyRdb.getInstance().queryAllUserInfo(getContext()).then((data) => {
            this.contactList = data;
            for(let i = 0; i < data.length; i++)
                console.log(`${data[i].name} ${data[i].phone}`);
        })
    }

    build() {
        Column({ space: 5 }) {
            List() {
                ForEach(this.contactList, (item: Info) => {
                    ListItem() {
                        ContactCard({ Contact: item })
                            .margin({ top: 20 })
                    }
                }, (item: Info) => item.name)
            }
            .onReachEnd(() => {
                this.isListReachEnd = true;
            })
            .parallelGesture(
                PanGesture({ direction: PanDirection.Up, distance: 80 })
                    .onActionStart(() => {
                        if (this.isListReachEnd) {
                            this.isListReachEnd = false;
                        }
                    })
            )
            .padding(20)
            .scrollBar(BarState.Off)
        }
        .width('100%')
        .height('100%')
        .backgroundColor(0xF1F3F5)
    }

}

@Component
struct ContactCard {
    @Prop Contact: Info;

    build() {
        Row() {
            Image('../resources/base/media/startIcon.png')
                .width(80)
                .height(80)
                .margin({ right: 20 })

            Column() {
                Text(this.Contact.name)
                    .fontSize(20)
                    .margin({ bottom: 8 })
                Text(this.Contact.phone)
                    .fontSize(16)
                    .fontColor(Color.Gray)
                    .margin({ bottom: 8 })
            }
            .alignItems(HorizontalAlign.Start)
            .width('60%')  // 缩小宽度以给按钮留空间
            .height('100%')

            Column() {
                Button('修改')
                    .onClick(() => {
                        router.pushUrl({ url: 'pages/EditContact', params: { id: this.Contact.id } });
                    })
                    .margin({ bottom: 8 })
                    .width('80%')

                Button('删除')
                    .onClick(() => {
                            MyRdb.getInstance().deleteUserInfo(getContext(), this.Contact.id).then(() => {
                        })
                    })
                    .width('80%')
            }
            .alignItems(HorizontalAlign.End)  // 将按钮右对齐
            .justifyContent(FlexAlign.Center)  // 垂直居中按钮
            .width('20%')  // 留出 20% 的宽度给按钮
            .height('100%')
        }
        .padding(20)
        .borderRadius(12)
        .backgroundColor('#FFECECEC')
        .height(120)
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
    }

}
