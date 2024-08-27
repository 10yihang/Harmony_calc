import router from '@ohos.router';
import { Context, featureAbility } from '@kit.AbilityKit';
import { initTable, queryData, deleteOneData } from '../ContactDB';

interface id_info {
    id: number;
    phone: string;
    name: string;
}

@Entry
@Component
struct ContactsPage {
    @State contactList: Array<id_info> = new Array();
    @State contact: id_info = { id: 0, phone: '', name: '' };
    @State index: number = 0

    aboutToAppear() {
        initTable(getContext());
        this.loadContacts();
    }

    loadContacts() {
        queryData(getContext(), { code: '%', page: 1, pageSize: 100 }).then((data) => {
            if (Array.isArray(data)) {
                this.contactList = [...data];
            }
        });
    }

    build() {
        Column() {
            ForEach(this.contactList, (contact: id_info) => {
                Row() {
                    Text(contact.name).fontSize(20).height(1);
                    Text(contact.phone).fontSize(20).height(1);
                    Button('Edit').onClick(() => {
                        router.pushUrl({ url: 'pages/EditContact', params: { id: contact.id } });
                    });
                    Button('Delete').onClick(() => {
                        this.deleteContact(contact.id);
                    });
                }.padding(10)
            })

            Button('Add Contact').onClick(() => {
                router.pushUrl({ url: 'pages/AddContact' });
            }).width('100%').height(50).fontSize(20);
        }.padding(20);
    }

    deleteContact(id: number) {
        // Delete a contact and refresh the list
        deleteOneData(getContext(), id).then(() => {
            this.loadContacts(); // Reload contacts after deletion
        });
    }
}
