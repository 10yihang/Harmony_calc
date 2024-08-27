import router from '@ohos.router';
import { MyRdb } from '../ContactDB';

class PARAMS {
    id: number = 0;
    name: string = '';
    phone: string = '';
}

@Entry
@Component
struct EditContactPage {
    @State name: string = '';
    @State phone: string = '';
    @State ID: number = 0;
    @Prop params: PARAMS = new PARAMS();

    aboutToAppear() {
        const receivedParams = router.getParams() as PARAMS;
        this.ID = receivedParams.id;
        this.name = receivedParams.name;
        this.phone = receivedParams.phone;
        console.info('PARAMS', `${receivedParams.id} ${receivedParams.name} ${receivedParams.phone}`)
    }

    build() {
        Column() {
            Text('Edit Contact').fontSize(30).padding(10);

            TextInput({ placeholder: 'Name', text: this.name })
                .onChange((value: string) => this.name = value)
                .width('100%').height(50).fontSize(20).padding(10);

            Text().height(10)

            TextInput({ placeholder: 'Phone', text: this.phone })
                .onChange((value: string) => this.phone = value)
                .width('100%').height(50).fontSize(20).padding(10);

            Text().height(10)

            Button('Save').onClick(() => {
                MyRdb.getInstance().updateUserInfo(getContext(this), this.ID, this.name, this.phone).then(() => {
                    router.back();
                });
            }).width('100%').height(50).fontSize(20).padding(10);

            Text().height(50)

            Button('Cancel').onClick(() => {
                router.back();
            }).width('100%').height(50).fontSize(20).padding(10);
        }.padding(20);
    }
}
