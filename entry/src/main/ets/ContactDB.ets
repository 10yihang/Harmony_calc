import relationalStore from '@ohos.data.relationalStore';
import { BusinessError } from '@kit.BasicServicesKit';
import relStore from '@ohos.data.relationalStore';

const STORE_CONFIG: relationalStore.StoreConfig = {
    name: "Contacts.db",
    securityLevel: relationalStore.SecurityLevel.S1
}


const TAB_USER = "user"
const CREATE_TABLE_CODE = "CREATE TABLE IF NOT EXISTS "+TAB_USER+" ("
    + "id INTEGER PRIMARY KEY AUTOINCREMENT, "
    + "name TEXT , "
    + "phone TEXT ) "

export function initTable(context: Context) {
    relationalStore.getRdbStore(context, STORE_CONFIG).then(async (rdbStore: relationalStore.RdbStore)=>{
        const promise = rdbStore.executeSql(CREATE_TABLE_CODE)
        return promise.then(async (result) => {
            console.log("创建成功")
        }).catch((err: BusinessError) => {
            console.error(`Query failed, code is ${err.code},message is ${err.message}`);
        })
    })
}

//插入
interface Info {
    name: string;
    phone: string;
}

interface QueryParams{
    code: string;
    page: number;
    pageSize: number;
}

interface  QueryResult{
    id: number,
    name: string,
    phone: string
}


//插入
export function insertData(context:Context, list: (Info)[]): Promise<boolean>{
    const promise = relationalStore.getRdbStore(context,STORE_CONFIG)
    return promise.then(async (rdbStore) => {
        for(let i:number=0; i<list.length; i++){
            const obj = list[i]
            const item: relationalStore.ValuesBucket = {
                name: obj.name,
                phone: obj.phone
            }
            console.info('----item---', JSON.stringify(item))
            rdbStore.insert(TAB_USER, item)
            console.log("插入成功")
        }
        return true;
    }).catch((err: BusinessError)=>{
        console.log(`Query failed, code is ${err.code},message is ${err.message}`);
        return false;
    })
}
//查询
export function queryData(context: Context,param: QueryParams): Promise<boolean | QueryResult[]>{
    let promise = relationalStore.getRdbStore(context, STORE_CONFIG)
    return promise.then(async (rdbStore) => {
        const sql: string = "select * from "+TAB_USER+" where name like ? " +
            "order by id  asc limit  ? OFFSET ? ";
        console.log('----sql---', sql)
        const pS = param.pageSize
        const page = param.page
        console.log('param.code', param.code)
        console.log('pS', pS)
        console.log('(page-1)*pS', (page - 1) * pS)
        // param.code,pS,(page-1)*pS]
        let promisequery = rdbStore.querySql(sql, [param.code, pS, (page - 1) * pS])
        return promisequery.then(async (resultSet) => {
            const rowCount = resultSet.rowCount;
            let list: QueryResult[] = [];
            console.log("rowCount --" + rowCount)
            resultSet.goToFirstRow();
            for (let i = 0; i < rowCount; i++) {
                const name = resultSet.getString(resultSet.getColumnIndex("NAME"))
                const phone = resultSet.getString(resultSet.getColumnIndex("PHONE"))
                const id = resultSet.getLong(resultSet.getColumnIndex("ID"))
                resultSet.goToNextRow();
                const data: QueryResult = {
                    id,
                    name,
                    phone,
                }
                list.push(data);
            }
            resultSet.close();
            console.log('--array--', list.length)
            return list;
        })
    }).catch((err: BusinessError) => {
        console.log(`Query failed, code is ${err.code},message is ${err.message}`);
        return false;
    })
}

//更新
export  function updateData(context:Context,newInfo: relationalStore.ValuesBucket):Promise<boolean>{
    const promise = relationalStore.getRdbStore(context,STORE_CONFIG)
    return promise.then(async (rdbStore) => {
        let predicates = new relationalStore.RdbPredicates(TAB_USER);
        predicates.equalTo("id", newInfo.id)
        let promiseUp = rdbStore.update(newInfo, predicates)
        return promiseUp.then(async (rows) => {
            if(rows == 1){
                console.log("更新成功")
                return true
            }
            return false;
        }).catch((err: BusinessError) => {
            console.log(`Query failed, code is ${err.code},message is ${err.message}`);
            return false;
        })
    })
}

export function deleteOneData(context:Context,id: number):Promise<boolean>{
    const promise = relationalStore.getRdbStore(context,STORE_CONFIG)
    return promise.then(async (rdbStore) => {
        let predicates = new relationalStore.RdbPredicates(TAB_USER);
        predicates.equalTo("id", id)
        const result = rdbStore.delete(predicates);
        console.log('--result--'+JSON.stringify(result))
        return true;
    }).catch((err: BusinessError) => {
        console.log(`Query failed, code is ${err.code},message is ${err.message}`);
        return false;
    })
}
