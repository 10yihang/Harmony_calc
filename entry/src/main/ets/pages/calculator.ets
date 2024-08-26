import router from '@ohos.router';


@Entry
@Component
struct Calculator {
    @State displayValue: string = '';
    @State currentOperator: string = '';
    @State firstOperand: string = '';
    @State waitingForSecondOperand: boolean = false;
    @State selectedMode: string = '标准';

    build() {
        Column() {
            Button('标准')
                .bindMenu([
                    {
                        value: '标准',
                        action: () => {
                            console.info('handle Menu1 select')
                        }
                    },{
                        value: '科学',
                        action: () => {
                            router.pushUrl({
                                url: 'pages/ScientificCalc',
                            })
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
                Button('C').width('23%').height(80).fontSize(24).onClick(() => {
                    this.displayValue = '';
                    this.firstOperand = '';
                    this.currentOperator = '';
                    this.waitingForSecondOperand = false;
                })
                    .margin({right: 5});
                Button('%').width('23%').height(80).fontSize(24).onClick(() => {
                    if (this.displayValue!== '' && this.waitingForSecondOperand === false) {
                        this.displayValue = (parseFloat(this.displayValue) / 100).toString();
                    }
                })
                    .margin({right: 5});
                Button('⌫').width('23%').height(80).fontSize(24).onClick(() => {
                    if (this.displayValue!== '') {
                        this.displayValue = this.displayValue.slice(0, -1);
                    }
                })
                    .margin({right: 5});
                Button('÷').width('23%').height(80).fontSize(24).onClick(() => {
                    this.performOperation('/');
                })
                    .margin({right: 5});
            };
            Text().height(5);
            Row() {
                Button('√').width('23%').height(80).fontSize(24).onClick(() => {
                    this.performScientificFunction('sqrt');
                })
                    .margin({right: 5});
                Button('log').width('23%').height(80).fontSize(24).onClick(() => {
                    this.performScientificFunction('log');
                })
                    .margin({right: 5});
                Button('ln').width('23%').height(80).fontSize(24).onClick(() => {
                    this.performScientificFunction('ln');
                })
                    .margin({right: 5});
                Button('^').width('23%').height(80).fontSize(24).onClick(() => {
                    this.performOperation('^');
                })
                    .margin({right: 5});
            }

            Text().height(5);

            Row() {

                Button('7').width('23%').height(80).fontSize(24).onClick(() => {
                    this.appendToDisplay('7');
                })
                    .margin({right: 5});
                Button('8').width('23%').height(80).fontSize(24).onClick(() => {
                    this.appendToDisplay('8');
                })
                    .margin({right: 5});
                Button('9').width('23%').height(80).fontSize(24).onClick(() => {
                    this.appendToDisplay('9');
                })
                    .margin({right: 5});
                Button('×').width('23%').height(80).fontSize(24).onClick(() => {
                    this.performOperation('*');
                })
                    .margin({right: 5});
            };

            Text().height(5);

            Row() {
                Button('4').width('23%').height(80).fontSize(24).onClick(() => {
                    this.appendToDisplay('4');
                })
                    .margin({right: 5});
                Button('5').width('23%').height(80).fontSize(24).onClick(() => {
                    this.appendToDisplay('5');
                })
                    .margin({right: 5});
                Button('6').width('23%').height(80).fontSize(24).onClick(() => {
                    this.appendToDisplay('6');
                })
                    .margin({right: 5});
                Button('-').width('23%').height(80).fontSize(24).onClick(() => {
                    if(this.displayValue!=='') this.performOperation('-');
                    else {
                        this.displayValue = '-';
                    }
                })
                    .margin({right: 5});
            };

            Text().height(5);

            Row() {
                Button('1').width('23%').height(80).fontSize(24).onClick(() => {
                    this.appendToDisplay('1');
                })
                    .margin({right: 5});
                Button('2').width('23%').height(80).fontSize(24).onClick(() => {
                    this.appendToDisplay('2');
                })
                    .margin({right: 5});
                Button('3').width('23%').height(80).fontSize(24).onClick(() => {
                    this.appendToDisplay('3');
                })
                    .margin({right: 5});
                Button('+').width('23%').height(80).fontSize(24).onClick(() => {
                    this.performOperation('+');
                })
                    .margin({right: 5});
            };

            Text().height(5);

            Row() {
                Button('±').width('23%').height(80).fontSize(24).onClick(() => {
                    if (this.displayValue!== '') {
                        this.displayValue = (parseFloat(this.displayValue) * -1).toString();
                    }
                })
                    .margin({right: 5});
                Button('0').width('23%').height(80).fontSize(24).onClick(() => {
                    this.appendToDisplay('0');
                })
                    .margin({right: 5});
                Button('.').width('23%').height(80).fontSize(24).onClick(() => {
                    if (!this.displayValue.includes('.')) {
                        this.appendToDisplay('.');
                    }
                })
                    .margin({right: 5});
                Button('=').width('23%').height(80).fontSize(24).onClick(() => {
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

    performScientificFunction(func: string) {
        if (this.displayValue!== '') {
            let num = parseFloat(this.displayValue);
            let result: number = 1;
            switch (func) {
                case 'pow':
                    return;
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