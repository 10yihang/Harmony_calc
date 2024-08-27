import router from '@ohos.router';
import { Context, featureAbility } from '@kit.AbilityKit';
import { MyRdb, Info } from '../ContactDB';
import { BusinessError } from '@kit.BasicServicesKit';
import {pinyin4js} from '@ohos/pinyin4js';

interface Contact {
    letter: string;
    data: Array<Info>;  // 这里可以根据实际情况指定类型
}

@Entry
@Component
struct ContactsPage {
    @State contactList: Array<Info> = new Array();
    @State contact: Info = new Info(0, '', '');
    @State index: number = 0;
    @State context: Context = getContext();
    @State isListReachEnd: boolean = false;
    @State letters: string[] = ['A','B','C','D','E','F','G', 'H','I','J', 'K','L','M','N', 'O','P','Q','R','S','T','U','V','W','X','Y','Z','#']
    @State flist:Contact[] = []
    @State isRefreshing: boolean = false
    @State needRefresh: boolean = false

    @Builder NavigationMenus() { // CustomBuilder类型的菜单栏
        Row() {
            Image('/images/contact_add.png')
                .size({ width: 24, height: 24 })
                .margin({ left: 5, top: 16 })
                .onClick(()=>{
                    router.pushUrl({
                        url: 'pages/AddContact'
                    })
                })
        }.justifyContent(FlexAlign.End)
    }

    @Builder
    NavigationTitle() {
        Row() {
            Text("通讯录")
                .fontSize(20)
                .width('100')
                .margin({ right: 'auto', left: 'auto' }) // Centers the text

            // Search button on the right
            // Image('../../resources/base/media/Bigger.png')
            Text('搜索')
                .fontSize(20)
                .onClick(() => {
                    // Handle the search button click event
                    router.pushUrl({ url: 'pages/ContactsSearch' });
                })
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween) // Distribute items with space between
        .padding({ left: 10, right: 10 })
    }


    @Builder itemHead(text:string) {
        Text(text)
            .fontSize(14)
            .backgroundColor('#E6E6E6')
            .width("120%")
            .padding({
                left: 15,
                top: 8,
                bottom: 8
            })
            .fontColor(Color.Gray)
            .margin({
                left: -15,
            })
    }

    private listScroller: Scroller = new Scroller();
    @State selectedIndex: number = 0;


    @Builder itemEnd(index: number) {
        // 侧滑后尾端出现的组件
        Button({ type: ButtonType.Circle }) {
            Image('../../resources/base/media/delete.png')
                .width(20)
                .height(20)
                .fillColor(Color.Red)
        }
        .backgroundColor(Color.Transparent)
        .padding(12)
        .margin({
            right: 18
        })
        .onClick(() => {
            MyRdb.getInstance().deleteUserInfo(getContext(), index).then(()=>{
                this.loadContacts()
                console.info('deleteUserInfo', index)
            })
        })
    }

    flistinit(){
        this.flist = []
        for(let i = 0; i < this.letters.length; i++){
            this.flist.push({
                letter: this.letters[i],
                data: []
            })
        }
    }

    async onPageShow() {
        await this.initializeAndLoadData();
    }

    async initializeAndLoadData() {
        await MyRdb.getInstance().initRdbStore(this.context);
        await MyRdb.getInstance().insertUser(this.context, 'Hyh', '1234567890');
        // await MyRdb.getInstance().insertUser(this.context, 'Jane Smith', '9876543210');
        // await MyRdb.getInstance().insertUser(this.context, 'Mike Brown', '5555555555');
        this.loadContacts();
    }

    sortContactsByLetter() {
        this.flist.sort((a, b) => {
            if (a.letter === '#') return 1;
            if (b.letter === '#') return -1;
            // 首先按 letter 排序
            const letterComparison = a.letter.localeCompare(b.letter);

            // 如果首字母相同，按 data 的长度排序（示例）
            if (letterComparison === 0) {
                return a.data.length - b.data.length; // 例如按 data 数组长度排序
            }

            return letterComparison;
        });
    }

    loadContacts():Promise<void> {
        this.flistinit()
        MyRdb.getInstance().queryAllUserInfo(getContext()).then((data) => {
            this.contactList = data;
            console.info('contactList', this.flist.length)
            for (let i = 0; i < data.length; i++) {
                console.info('contactList', `${data[i].id} ${data[i].name} ${data[i].phone}`)
                if(data[i].name.charAt(0) >= '0' && data[i].name.charAt(0) <= '9') this.flist[this.letters.length-1].data.push(data[i])
                else {
                    if(data[i].name.charAt(0) >= 'A' && data[i].name.charAt(0) <= 'Z') {
                        let index = data[i].name.charCodeAt(0) - 'A'.charCodeAt(0);
                        this.flist[index].data.push(data[i])
                    } else if(data[i].name.charAt(0) >= 'a' && data[i].name.charAt(0) <= 'z') {
                        let index = data[i].name.charCodeAt(0) - 'a'.charCodeAt(0);
                        this.flist[index].data.push(data[i])
                    } else {
                        let str: string = pinyin4js.getFirstLetter(data[i].name, pinyin4js.FIRST_LETTER);
                        if(str.charAt(0) >= 'A' && str.charAt(0) <= 'Z') {
                            let index = str.charCodeAt(0) - 'A'.charCodeAt(0);
                            this.flist[index].data.push(data[i])
                        } else if(str.charAt(0) >= 'a' && str.charAt(0) <= 'z') {
                            let index = str.charCodeAt(0) - 'a'.charCodeAt(0);
                            this.flist[index].data.push(data[i])
                        }
                    }
                }
            }
        });
        this.sortContactsByLetter();
        console.info('flist', this.flist)
        return Promise.resolve()
    }

    build() {
        Column() {
            Refresh({ refreshing: $$this.isRefreshing}) {
                Navigation() {
                    Stack({ alignContent: Alignment.End }) {
                        Column() {
                            List({ scroller: this.listScroller }) {
                                ListItemGroup() {
                                    ListItem() {
                                        ContactsRow({ imagePath: '/images/contact_0.png', titleString: '新的朋友' })
                                    }.onClick(() => {
                                        router.pushUrl({
                                            url: 'pages/AddContact'
                                        })
                                    })
                                }
                                .padding({ left: 15, right: 15 })
                                .divider({
                                    strokeWidth: 2,
                                    color: 'rgb(247,247,247)',
                                    startMargin: 60,
                                    endMargin: 0
                                })

                                ForEach(this.flist, (item: Contact, index: number) => {
                                    ListItemGroup({ header: this.itemHead(item.letter) }) {
                                        ForEach(item.data, (p: Info, i: number) => {
                                            ListItem() {
                                                Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
                                                    Image('../../resources/base/media/startIcon.png')
                                                        .width(45)
                                                        .height(45)
                                                        .borderRadius(5)
                                                    Text(p.name)
                                                        .fontSize(18)
                                                        .margin({ left: 10 })
                                                        .onClick(() => {
                                                        })
                                                    Text(p.phone)
                                                        .fontSize(14)
                                                        .margin({ left: 10 })
                                                }
                                                .height(55)
                                            }.swipeAction({ end: this.itemEnd.bind(this, p.id) })
                                            .onClick(() => {
                                                router.pushUrl({
                                                    url: 'pages/EditContact', params: {
                                                        id: p.id,
                                                        name: p.name,
                                                        phone: p.phone
                                                    }
                                                })
                                            })
                                        })

                                    }
                                    .divider({
                                        strokeWidth: 2,
                                        color: 'rgb(247,247,247)',
                                        startMargin: 60,
                                        endMargin: 0
                                    })
                                    .padding({ left: 15, right: 15 })
                                    .margin({ top: 10 })
                                })

                            }
                            .divider({
                                strokeWidth: 2,
                                color: 'rgb(247,247,247)',
                                startMargin: 60,
                                endMargin: 0
                            })
                            .margin({ top: 17 })
                            .backgroundColor(Color.White)
                            .height('100%')
                            .onScrollIndex((firstIndex: number) => {
                                this.selectedIndex = firstIndex
                                console.log('**************', firstIndex);
                                if (firstIndex > 2) {
                                    this.selectedIndex =
                                        this.flist.findIndex(i => i.letter === this.flist[firstIndex - 3]?.letter);
                                }
                            })
                        }


                        AlphabetIndexer({ arrayValue: this.letters, selected: 0 })
                            .color(Color.Black)
                            .selectedColor(0xFFFFFF)// 选中项文本颜色
                            .popupColor(0xFFFAF0)// 弹出框文本颜色
                            .selectedBackgroundColor('rgb(1,196,194)')// 选中项背景颜色
                            .popupBackground(0xD2B48C)// 弹出框背景颜色
                            .usingPopup(true)// 是否显示弹出框
                            .selectedFont({ size: 13, weight: FontWeight.Bolder })// 选中项字体样式
                            .popupFont({ size: 30, weight: FontWeight.Bolder })// 弹出框内容的字体样式
                            .itemSize(20)// 每一项的尺寸大小
                            .alignStyle(IndexerAlign.Left)// 弹出框在索引条左侧弹出
                            .onSelect((index: number) => {
                                console.info(this.letters[index] + ' Selected!', index)
                                this.listScroller.scrollToIndex(index)
                            })
                            .onPopupSelect((index: number) => {
                                console.info('onPopupSelected:' + index)
                            })
                            .selected(this.selectedIndex)

                    }
                    .width('100%')
                    .height('100%')
                }
                .title(this.NavigationTitle())
                .mode(NavigationMode.Stack)
                .titleMode(NavigationTitleMode.Mini)
                .hideBackButton(true)
                .menus(this.NavigationMenus())
                .size({ width: '100%', height: '100%' })
                .backgroundColor('rgb(237,237,237)')
            }.onStateChange((state: RefreshStatus) => {
                console.info('Refreshing', RefreshStatus)
            })
            .onRefreshing(()=>{
                this.loadContacts().then(()=>{
                    setTimeout(()=>{
                        this.isRefreshing = false;
                    }, 1000)
                })
            })
            .backgroundColor(0x89CFF0)
        }
        // .bindMenu(this.MyMenu())
        .width('100%')
        .height('95%')
    }
}

@Component
struct ContactsRow {
    imagePath:string | Resource = ''
    titleString:string = ''
    count?: number = 0

    build(){
        Flex({direction:FlexDirection.Row,alignItems:ItemAlign.Center}){
            Badge({
                count: 0,
                position: BadgePosition.RightTop,
                style: { badgeSize: 16, badgeColor: '#FA2A2D' }
            })
            Text(this.titleString)
                .fontSize(18)
                .margin({left:10})

            // Button({ type: ButtonType.Circle }) {
            //     Image('../../resources/base/media/Bigger.png') // Use appropriate icon for search
            //         .width(24)
            //         .height(24)
            // }
            // .padding({ left: 10 })
            // .onClick(() => {
            //     router.pushUrl({
            //         url: 'pages/ContactsSearch'
            //     })
            // })
        }
        .height(55)
    }
}
