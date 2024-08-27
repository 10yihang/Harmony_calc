import router from '@ohos.router';
import { queryData, updateData } from '../ContactDB';



@Entry
@Component
struct EditContactPage {
    @State name: string = '';
    @State phone: string = '';
    @State ID: number = 0;

    aboutToAppear() {
        const params = router.getParams() as number;
        this.ID = params;

        // queryData(getContext(this), { code: '%', page: 1, pageSize: 100 }).then((data) => {
        //     const contact = data.find((item) => item.id === this.ID);
        //     if (contact) {
        //         this.name = contact.name;
        //         this.phone = contact.phone;
        //     }
        // });
    }

    build() {
        Column() {
            Text('Edit Contact').fontSize(30).padding(10);

            TextInput({ placeholder: 'Name', text: this.name })
                .onChange((value: string) => this.name = value)
                .width('100%').height(50).fontSize(20).padding(10);

            TextInput({ placeholder: 'Phone', text: this.phone })
                .onChange((value: string) => this.phone = value)
                .width('100%').height(50).fontSize(20).padding(10);

            Button('Save').onClick(() => {
                updateData(getContext(this), { id: this.ID, name: this.name, phone: this.phone }).then(() => {
                    router.back(0);
                });
            }).width('100%').height(50).fontSize(20).padding(10);

            Button('Cancel').onClick(() => {
                router.back();
            }).width('100%').height(50).fontSize(20).padding(10);
        }.padding(20);
    }
}
