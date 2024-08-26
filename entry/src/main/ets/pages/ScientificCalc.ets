import router from '@ohos.router';
import ArrayList from '@ohos.util.ArrayList'


@Entry
@Component
struct Calculator {
    @State displayValue: string = '';
    @State currentOperator: string = '';
    @State firstOperand: string = '';
    @State waitingForSecondOperand: boolean = false;
    @State selectedMode: string = '科学';
    @State Functions: ArrayList<string> = new ArrayList();
    @State FunctionMode: boolean = false;
    @State FunctionFini: boolean = false;
    @State pi: number = 3.141592653589793;
    @State e: number = 2.718281828459045;

    build() {
        Column() {
            Button('科学')
                .bindMenu([
                    {
                        value: '标准',
                        action: () => {
                            router.pushUrl({
                                url: 'pages/calculator',
                            })
                        }
                    },{
                    value: '科学',
                    action: () => {
                        console.info("science")
                    }
                }, {
                    value: '程序员',
                    action: () => {
                        router.pushUrl({
                            url: 'pages/CoderCalc',
                        })
                    }
                }
                ])

            Text('').height(10)

            TextInput({ text: this.displayValue })
                .width('100%')
                .height(100)
                .fontSize(50)
                .border({ width: 1 })
                .margin({ top: 20 })


            Text('').height(20);

            // 按钮布局
            Row() {
                Button('π').width('18%').height(60).fontSize(18).onClick(() => {
                    if(this.FunctionMode){
                        this.displayValue += 'π';
                        if(!this.checkBase(this.Functions[this.Functions.length - 1]))   {
                            this.lstInsert('π');
                        }
                        this.Functions.add('π');
                    } else this.displayValue = this.pi.toString();
                })
                    .margin({right: 5});
                Button('C').width('18%').height(60).fontSize(18).onClick(() => {
                    this.displayValue = '';
                    this.firstOperand = '';
                    this.currentOperator = '';
                    this.waitingForSecondOperand = false;
                    if(this.FunctionMode){
                        this.displayValue += 'x';
                        this.Functions.clear();
                        this.FunctionFini = false;
                    }
                })
                    .margin({right: 5});
                Button('%').width('18%').height(60).fontSize(18).onClick(() => {
                    if(this.FunctionMode){
                        this.displayValue += '%';
                        if(!this.checkBase(this.Functions[this.Functions.length - 1]))   {
                            this.lstInsert('%');
                        }
                        this.Functions.add('%');
                    } else if (this.displayValue!== '' && this.waitingForSecondOperand === false) {
                        this.displayValue = (parseFloat(this.displayValue) / 100).toString();
                    }
                })
                    .margin({right: 5});
                Button('⌫').width('18%').height(60).fontSize(18).onClick(() => {
                    if (this.displayValue!== '') {
                        this.displayValue = this.displayValue.slice(0, -1);
                    }
                })
                    .margin({right: 5});
                Button('÷').width('18%').height(60).fontSize(18).onClick(() => {
                    this.performOperation('/');
                })
                    .margin({right: 5});
            };
            Text().height(5);
            Row() {
                Button('e').width('18%').height(60).fontSize(18).onClick(() => {
                    this.displayValue = this.e.toString();
                })
                    .margin({right: 5});
                Button('√').width('18%').height(60).fontSize(18).onClick(() => {
                    this.performScientificFunction('sqrt');
                })
                    .margin({right: 5});
                Button('log').width('18%').height(60).fontSize(18).onClick(() => {
                    this.performScientificFunction('log');
                })
                    .margin({right: 5});
                Button('ln').width('18%').height(60).fontSize(18).onClick(() => {
                    this.performScientificFunction('ln');
                })
                    .margin({right: 5});
                Button('^').width('18%').height(60).fontSize(18).onClick(() => {
                    this.performOperation('^');
                })
                    .margin({right: 5});
            }
            Text().height(5);
            Row() {
                Button('mo').width('18%').height(60).fontSize(18).onClick(() => {
                    this.performOperation('%');
                })
                    .margin({right: 5});
                Button('abs').width('18%').height(60).fontSize(18).onClick(()=>{
                    this.performScientificFunction('abs');
                })
                    .margin({right: 5});
                Button('sin').width('18%').height(60).fontSize(18).onClick(()=>{
                    this.performScientificFunction('sin');
                })
                    .margin({right: 5});
                Button('cos').width('18%').height(60).fontSize(18).onClick(()=>{
                    this.performScientificFunction('cos');
                })
                    .margin({right: 5});
                Button('tan').width('18%').height(60).fontSize(18).onClick(()=>{
                    this.performScientificFunction('tan');
                })
                    .margin({right: 5});
            }

            Text().height(5);

            Row() {
                Button('!').width('18%').height(60).fontSize(18).onClick(()=>{
                    this.performScientificFunction('factorial');
                })
                    .margin({right: 5});
                Button('7').width('18%').height(60).fontSize(18).onClick(() => {
                    this.appendToDisplay('7');
                })
                    .margin({right: 5});
                Button('8').width('18%').height(60).fontSize(18).onClick(() => {
                    this.appendToDisplay('8');
                })
                    .margin({right: 5});
                Button('9').width('18%').height(60).fontSize(18).onClick(() => {
                    this.appendToDisplay('9');
                })
                    .margin({right: 5});
                Button('×').width('18%').height(60).fontSize(18).onClick(() => {
                    this.performOperation('*');
                })
                    .margin({right: 5});
            };

            Text().height(5);

            Row() {
                Button('art').width('18%').height(60).fontSize(18).onClick(()=>{
                    this.performScientificFunction('arctan');
                })
                    .margin({right: 5});
                Button('4').width('18%').height(60).fontSize(18).onClick(() => {
                    this.appendToDisplay('4');
                })
                    .margin({right: 5});
                Button('5').width('18%').height(60).fontSize(18).onClick(() => {
                    this.appendToDisplay('5');
                })
                    .margin({right: 5});
                Button('6').width('18%').height(60).fontSize(18).onClick(() => {
                    this.appendToDisplay('6');
                })
                    .margin({right: 5});
                Button('-').width('18%').height(60).fontSize(18).onClick(() => {
                    if(this.displayValue!=='') this.performOperation('-');
                    else {
                        this.displayValue = '-';
                    }
                })
            };

            Text().height(5);

            Row() {
                Button('inv').width('18%').height(60).fontSize(18).onClick(()=>{
                    this.performScientificFunction('inv');
                })
                    .margin({right: 5});
                Button('1').width('18%').height(60).fontSize(18).onClick(() => {
                    this.appendToDisplay('1');
                })
                    .margin({right: 5});
                Button('2').width('18%').height(60).fontSize(18).onClick(() => {
                    this.appendToDisplay('2');
                })
                    .margin({right: 5});
                Button('3').width('18%').height(60).fontSize(18).onClick(() => {
                    this.appendToDisplay('3');
                })
                    .margin({right: 5});
                Button('+').width('18%').height(60).fontSize(18).onClick(() => {
                    this.performOperation('+');
                })
                    .margin({right: 5});
            };

            Text().height(5);

            Row() {
                Button('fun').width('18%').height(60).fontSize(18).onClick(()=>{
                    this.FunctionMode = !this.FunctionMode;
                    if(this.FunctionMode){
                        this.displayValue = 'x';
                    }
                })
                    .margin({right: 5});
                Button('±').width('18%').height(60).fontSize(18).onClick(() => {
                    if (this.displayValue!== '') {
                        this.displayValue = (parseFloat(this.displayValue) * -1).toString();
                    }
                })
                    .margin({right: 5});
                Button('0').width('18%').height(60).fontSize(18).onClick(() => {
                    this.appendToDisplay('0');
                })
                    .margin({right: 5});
                Button('.').width('18%').height(60).fontSize(18).onClick(() => {
                    if (!this.displayValue.includes('.')) {
                        this.appendToDisplay('.');
                    }
                })
                    .margin({right: 5});
                Button('=').width('18%').height(60).fontSize(18).onClick(() => {
                    this.performEqual();
                })
                    .margin({right: 5});
            };

        }
        .width('100%')
        .height('100%');
    }

    appendToDisplay(value: string) {
        if (this.waitingForSecondOperand === false) {
            this.displayValue += value;
        } else {
            this.displayValue = value;
            this.waitingForSecondOperand = false;
        }
    }

    performOperation(operator: string) {
        if (this.displayValue!== '') {
            if (this.firstOperand === '' && this.currentOperator === '') {
                this.firstOperand = this.displayValue;
                this.currentOperator = operator;
                this.displayValue = '';
            } else {
                this.performEqual();
                this.currentOperator = operator;
            }
        }
    }

    performEqual() {
        if (this.displayValue!== '' && this.firstOperand!== '' && this.currentOperator!== '') {
            let num1 = parseFloat(this.firstOperand);
            let num2 = parseFloat(this.displayValue);
            let result: number;
            switch (this.currentOperator) {
                case '%':
                    result = num1 % num2;
                    break;
                case '+':
                    result = num1 + num2;
                    break;
                case '-':
                    result = num1 - num2;
                    break;
                case '*':
                    result = num1 * num2;
                    break;
                case '^':
                    result = Math.pow(num1, num2);
                    break;
                case '/':
                    if (num2!== 0) {
                        result = num1 / num2;
                    } else {
                        result = NaN;
                        this.displayValue = 'Error: Division by zero';
                        return;
                    }
                    break;
                default:
                    result = num1;
            }
            this.displayValue = result.toString();
            this.firstOperand = '';
            this.currentOperator = '';
            this.waitingForSecondOperand = false;
        }
    }

    checkBase(c: string): boolean{
    const operators = ['+', '-', '*', '/', '^'];
    return !operators.includes(c);
};

    funcRecord(str: string){
        this.Functions.add(str);
    }

    preInsert(str: string) {
        this.displayValue = str + '(' + this.displayValue + ')';
    }

    lstInsert(str: string){
        this.displayValue = '(' + this.displayValue + ')' + str;
    }

    factorial(n: number): number {
        let res: number = 1;
        for (let i = 1; i <= n; i++) {
            res *= i;
        }
        return res;
    }

    performScientificFunction(func: string) {
        if (this.displayValue!== '') {
            let num = parseFloat(this.displayValue);
            let result: number = 1;
            switch (func) {
                case 'inv':
                    if(num === 0){
                        result = NaN;
                        this.displayValue = 'Error: Division by zero';
                        return;
                    }
                    result = 1.0 / num;
                    break;
                case 'factorial':
                    result = this.factorial(num);
                    break;
                case 'abs':
                    result = Math.abs(num);
                    break;
                case 'sin':
                    result = Math.sin(num);
                    break;
                case 'cos':
                    result = Math.cos(num);
                    break;
                case 'tan':
                    result = Math.tan(num);
                    if (isNaN(result)) {
                        result = NaN
                    }
                    if (result === Infinity) {
                        result = NaN;
                        this.displayValue = 'Error: Invalid input for tangent';
                        return;
                    }
                    if (result === -Infinity) {
                        result = NaN;
                        this.displayValue = 'Error: Invalid input for tangent';
                        return;
                    }
                    break;
                case 'arcsin':
                    if (num >= -1 && num <= 1) {
                        result = Math.asin(num);
                    } else {
                        result = NaN;
                        this.displayValue = 'Error: Invalid input for arcsine';
                        return;
                    }
                    break;
                case 'arctan':
                    result = Math.atan(num);
                    if (isNaN(result)) {
                        result = NaN;
                        this.displayValue = 'Error: Invalid input for arctangent';
                        return;
                    }
                    break;
                case 'ln':
                    if (num > 0) {
                        result = Math.log(num);
                    } else {
                        result = NaN;
                        this.displayValue = 'Error: Invalid input for logarithm';
                        return;
                    }
                    break;
                case 'sqrt':
                    if (num >= 0) {
                        result = Math.sqrt(num);
                    } else {
                        result = NaN;
                        this.displayValue = 'Error: Negative number for square root';
                        return;
                    }
                    break;
                case 'log':
                    if (num > 0) {
                        result = Math.log10(num);
                    } else {
                        result = NaN;
                        this.displayValue = 'Error: Invalid input for logarithm';
                        return;
                    }
                    break;
            }
            this.displayValue = result.toString();
        }
    }


}