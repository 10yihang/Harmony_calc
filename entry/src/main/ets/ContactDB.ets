import relationalStore from '@ohos.data.relationalStore';
import { BusinessError } from '@kit.BasicServicesKit';
import common from '@ohos.app.ability.common';
import { ValuesBucket } from '@kit.ArkData';

export class Info {
    id: number;
    name: string;
    phone: string;

    constructor(id: number, name: string, phone: string) {
        this.id = id;
        this.name = name;
        this.phone = phone;
    }
}

export class MyRdb {
    private static instance: MyRdb | undefined = undefined
    private rdbStore: relationalStore.RdbStore | undefined = undefined
    private TABLE_NAME: string = 'User'

    public static getInstance(): MyRdb {
        if(!MyRdb.instance) {
            MyRdb.instance = new MyRdb()
        }
        return MyRdb.instance
    }

    public async initRdbStore(context: Context): Promise<void> {
        console.info('initRdbStore', 'init rdbStore begin')
        if (!context) {
            console.error('initRdbStore', 'initRdbStore context is invaild')
            return
        }
        if (this.rdbStore) {
            console.info('initRdbStore', 'init rdbStore exist')
            return
        }

        const config: relationalStore.StoreConfig = {
            name: "Contacts.db",
            securityLevel: relationalStore.SecurityLevel.S1
        }

        try {
            this.rdbStore = await relationalStore.getRdbStore(context, config)
            console.info('initRdbStore', 'init rdbStore success');

            await this.createTable()
        } catch (err) {
            console.info(`getRdbStore failed, error: ${err}`)
        }

    }

    public async insertUser(context: common.Context, name: string, phone: string): Promise<void> {
        console.info('insertUser', 'insertUser begin');
        if(!context) {
            console.error('insertUser', 'context is null or undefined')
            return
        }
        if(!this.rdbStore) {
            console.info('insertUser', 'rdbStore is null or undefined')
            await this.initRdbStore(context)
        }

        const valueBucket: ValuesBucket= {
            name: name,
            phone: phone
        }

        await this.rdbStore!!.insert(this.TABLE_NAME, valueBucket, relationalStore.ConflictResolution.ON_CONFLICT_REPLACE)
        console.info('insertUser', `insertUser ${name}  ${phone} success`)
}

    private async createTable(): Promise<void> {
        console.info('createTable', 'createTable begin');
        const TABLESQL = 'CREATE TABLE IF NOT EXISTS User (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, phone TEXT)'

        if(this.rdbStore != undefined) {
            await this.rdbStore.executeSql(TABLESQL)
            console.info('createTable', 'createTable success');
        }
    } catch(err: BusinessError) {
        console.error('createTable', `createTable failed, error: ${err}`)
    }

     public async queryUserInfo(context: common.Context, id: number, phone: string, name: string): Promise<Array<Info>> {
        console.info('queryUserInfo', 'queryUserInfo begin')
         if(!context) {
             console.error('insertUser', 'context is null or undefined')
             return []
         }
         if(!this.rdbStore) {
             console.info('insertUser', 'rdbStore is null or undefined')
             await this.initRdbStore(context)
         }

         let predicates = new relationalStore.RdbPredicates(this.TABLE_NAME)

         if (predicates === null || predicates === undefined) {
             console.info('queryUserInfo', 'predicates is null or undefined')
             return []
         }

         if (id) {
             predicates = predicates.equalTo("id", id);
         }
         if (name) {
             predicates = predicates.equalTo("name", name);
         }
         if (phone) {
             predicates = predicates.equalTo("phone", phone);
         }
         let resultSet = await this.rdbStore!!.query(predicates)

         let list: Array<Info> = []
         while(resultSet.goToNextRow()){
             list.push(new Info(resultSet.getLong(0), resultSet.getString(1), resultSet.getString(2)))
         }
         return list
     }

     public async queryAllUserInfo(context: common.Context): Promise<Array<Info>> {
         console.info('queryAllUserInfo', 'queryAllUserInfo begin')
         if(!context) {
             console.error('queryAllUserInfo', 'context is null or undefined')
             return []
         }
         if(!this.rdbStore) {
             console.info('queryAllUserInfo', 'rdbStore is null or undefined')
             await this.initRdbStore(context)
         }

         let predicates = new relationalStore.RdbPredicates(this.TABLE_NAME)
         let resultSet = await this.rdbStore!!.query(predicates)
         let list: Array<Info> = []
         while(resultSet.goToNextRow()){
             list.push(new Info(resultSet.getLong(0), resultSet.getString(1), resultSet.getString(2)))
             console.info('queryAllUserInfo', `${resultSet.getLong(0)} ${resultSet.getString(1)} ${resultSet.getString(2)}`)
         }
         return list
     }

     public async deleteUserInfo(context: common.Context, id: number): Promise<void> {
        console.info('deleteUserInfo', 'deleteUserInfo begin')
         if(!context) {
             console.error('deleteUserInfo', 'context is null or undefined')
             return
        }
         if(!this.rdbStore) {
             console.info('deleteUserInfo', 'rdbStore is null or undefined')
             await this.initRdbStore(context)
         }
         await this.rdbStore!!.delete(new relationalStore.RdbPredicates(this.TABLE_NAME).equalTo("id", id)).then(()=>{
             console.info('deleteUserInfo', 'deleteUserInfo success')
         }).catch((err: BusinessError)=>{
             console.error('deleteUserInfo', `deleteUserInfo failed, error: ${err}`)
         })
     }

     public async updateUserInfo(context: common.Context, id: number, name: string, phone: string): Promise<void> {
        console.info('updateUserInfo', 'updateUserInfo begin')
         if(!context) {
             console.error('updateUserInfo', 'context is null or undefined')
             return
         }
         if(!this.rdbStore) {
             console.info('updateUserInfo', 'rdbStore is null or undefined')
             await this.initRdbStore(context)
         }
         await this.rdbStore!!.update({name: name, phone: phone}, new relationalStore.RdbPredicates(this.TABLE_NAME).equalTo("id", id)).then(()=>{
             console.info('updateUserInfo', 'updateUserInfo success')
         }).catch((err: BusinessError)=>{
             console.error('updateUserInfo', `updateUserInfo failed, error: ${err}`)
         })
     }
}