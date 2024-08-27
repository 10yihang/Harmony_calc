import router from '@ohos.router';
import { Context } from '@kit.AbilityKit';
import { MyRdb, Info } from '../ContactDB';

@Entry
@Component
struct SearchPage {
    @State contactList: Array<Info> = new Array();
    @State searchQuery: string = '';
    @State filteredContacts: Array<Info> = new Array();
    @State context: Context = getContext();

    async onPageShow() {
        await this.loadContacts();
    }

    async loadContacts() {
        await MyRdb.getInstance().initRdbStore(this.context);
        MyRdb.getInstance().queryAllUserInfo(this.context).then((data) => {
            this.contactList = data;
            this.filteredContacts = data; // Initially show all contacts
        });
    }

    onSearchChange(newQuery: string) {
        this.searchQuery = newQuery;
        if (this.searchQuery.trim() === '') {
            this.filteredContacts = this.contactList;
        } else {
            this.filteredContacts = this.contactList.filter((contact) =>
            contact.name.toLowerCase().includes(this.searchQuery.toLowerCase()) ||
            contact.phone.includes(this.searchQuery)
            );
        }
    }

     build() {
        Column() {
            Row() {
                Image('../../resources/base/media/Bigger.png')
                    .width(24)
                    .height(24)
                    .margin({ right: 10 });
                TextInput({ placeholder: '搜索' })
                    .width('100%')
                    .onChange((value: string) => this.onSearchChange(value))
            }
            .padding({ left: 10, right: 10, top: 10, bottom: 10 })
            .backgroundColor('#F5F5F5')

            Scroll() {
                Column() {
                    ForEach(this.filteredContacts, (contact: Info, index: number) => {
                        ListItem() {
                            Row() {
                                Text(contact.name)
                                    .fontSize(16)
                                    .margin({ left: 10 })
                                Text(contact.phone)
                                    .fontSize(14)
                                    .margin({ left: 20 })
                            }
                            .padding({ left: 10, right: 10, top: 10, bottom: 10 })
                            .onClick(() => {
                                router.pushUrl({
                                    url: 'pages/EditContact',
                                    params: {
                                        id: contact.id,
                                        name: contact.name,
                                        phone: contact.phone,
                                    }
                                });
                            })
                        }
                        .backgroundColor(Color.White)
                        Text().height(5)
                    })
                }
            }
            .width('100%')
            .height('100%')
            .backgroundColor('#FFFFFF')
        }
        .width('100%')
        .height('100%')
        .backgroundColor('#FFFFFF')
    }
}