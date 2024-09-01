import router from '@ohos.router';
import { MyRdb } from '../ContactDB';

@Entry
@Component
struct AddContactPage {
    @State name: string = '';
    @State phone: string = '';

    build() {
        Column() {
            Text('添加联系人').fontSize(30).padding(10);

            TextInput({ placeholder: 'Name', text: this.name })
                .onChange((value: string) => this.name = value)
                .width('100%').height(50).fontSize(20).padding(10);

            Text().height(10)

            TextInput({ placeholder: 'Phone', text: this.phone })
                .onChange((value: string) => this.phone = value)
                .width('100%').height(50).fontSize(20).padding(10);

            Text().height(10)

            Button('Save').onClick(() => {
                if (this.name !== '' && this.phone !== '') {
                    MyRdb.getInstance().insertUser(getContext(this), this.name, this.phone).then(() => {
                        router.back();
                    });
                }
            }).width('100%').height(50).fontSize(20).padding(10);

            Text().height(50)

            Button('Cancel').onClick(() => {
                router.back();
            }).width('100%').height(50).fontSize(20).padding(10);
        }.padding(20);
    }
}
