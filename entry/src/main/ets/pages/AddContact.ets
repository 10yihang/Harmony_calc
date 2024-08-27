import router from '@ohos.router';
import { insertData } from '../ContactDB';

@Entry
@Component
struct AddContactPage {
    @State name: string = '';
    @State phone: string = '';

    build() {
        Column() {
            Text('Add Contact').fontSize(30).padding(10);

            TextInput({ placeholder: 'Name', text: this.name })
                .onChange((value: string) => this.name = value)
                .width('100%').height(50).fontSize(20).padding(10);

            TextInput({ placeholder: 'Phone', text: this.phone })
                .onChange((value: string) => this.phone = value)
                .width('100%').height(50).fontSize(20).padding(10);

            Button('Save').onClick(() => {
                if (this.name !== '' && this.phone !== '') {
                    insertData(getContext(this), [{ name: this.name, phone: this.phone }]).then(() => {
                        router.back(0);
                    });
                }
            }).width('100%').height(50).fontSize(20).padding(10);

            Button('Cancel').onClick(() => {
                router.back();
            }).width('100%').height(50).fontSize(20).padding(10);
        }.padding(20);
    }
}
