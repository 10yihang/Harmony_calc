import router from '@ohos.router';

@Entry
@Component
struct CoderCalc {
    @State displayValue: string = '';
    @State currentOperator: string = '';
    @State firstOperand: string = '';
    @State waitingForSecondOperand: boolean = false;
    @State selectedMode: string = '程序员';

    // 用于存储不同进制的数值
    @State binaryValue: string = '';
    @State octalValue: string = '';
    @State decimalValue: string = '';
    @State hexadecimalValue: string = '';

    build() {
        Column() {
            Button('程序员')
                .bindMenu([
                    {
                        value: '标准',
                        action: () => {
                            router.pushUrl({
                                url: 'pages/calculator'
                            })
                        }
                    },
                    {
                        value: '科学',
                        action: () => {
                            router.pushUrl({
                                url: 'pages/ScientificCalc',
                            });
                        }
                    },
                    {
                        value: '程序员',
                        action: () => {
                            this.selectedMode = '程序员';
                            this.updateAllBases(this.displayValue);
                        }
                    }
                ]);

            Text('').height(10);

            TextInput({ text: this.displayValue })
                .width('100%')
                .height(100)
                .fontSize(50)
                .border({ width: 1 })
                .margin({ top: 20 });

            Text('').height(20);

            // 按钮布局
            Row() {
                Button('C').width('23%').height(60).fontSize(24).onClick(() => {
                    this.displayValue = '';
                    this.firstOperand = '';
                    this.currentOperator = '';
                    this.waitingForSecondOperand = false;
                    this.binaryValue = '';
                    this.octalValue = '';
                    this.decimalValue = '';
                    this.hexadecimalValue = '';
                })
                    .margin({ right: 5 });

                Button('^').width('23%').height(60).fontSize(24).onClick(() => {
                    this.performOperation('^')
                })
                    .margin({ right: 5 });

                Button('|').width('23%').height(60).fontSize(24).onClick(() => {
                    this.performOperation('|')
                })
                    .margin({ right: 5 });

                Button('&').width('23%').height(60).fontSize(24).onClick(() => {
                    this.performOperation('&')
                })
                    .margin({ right: 5 });
            };

            Text().height(5);

            Row(){
                Button('<<').width('45%').height(60).fontSize(24).onClick(() => {
                    if (this.displayValue!== '') {
                        this.displayValue = this.leftShift(parseInt(this.displayValue)).toString();
                        this.updateAllBases(this.displayValue);
                    }
                })
                    .margin({ right: 5 });
                Button('>>').width('45%').height(60).fontSize(24).onClick(() => {
                    if (this.displayValue!== '') {
                        this.displayValue = this.rightShift(parseInt(this.displayValue)).toString();
                        this.updateAllBases(this.displayValue);
                    }
                })
                    .margin({ right: 5 });
            }
            Text().height(5);

            Row() {
                Button('7').width('23%').height(60).fontSize(24).onClick(() => {
                    this.appendToDisplay('7');
                })
                    .margin({ right: 5 });
                Button('8').width('23%').height(60).fontSize(24).onClick(() => {
                    this.appendToDisplay('8');
                })
                    .margin({ right: 5 });
                Button('9').width('23%').height(60).fontSize(24).onClick(() => {
                    this.appendToDisplay('9');
                })
                    .margin({ right: 5 });
                Button('×').width('23%').height(60).fontSize(24).onClick(() => {
                    this.performOperation('*');
                })
                    .margin({ right: 5 });
            };

            Text().height(5);

            Row() {
                Button('4').width('23%').height(60).fontSize(24).onClick(() => {
                    this.appendToDisplay('4');
                })
                    .margin({ right: 5 });
                Button('5').width('23%').height(60).fontSize(24).onClick(() => {
                    this.appendToDisplay('5');
                })
                    .margin({ right: 5 });
                Button('6').width('23%').height(60).fontSize(24).onClick(() => {
                    this.appendToDisplay('6');
                })
                    .margin({ right: 5 });
                Button('-').width('23%').height(60).fontSize(24).onClick(() => {
                    if (this.displayValue!== '') {
                        this.performOperation('-');
                    } else {
                        this.displayValue = '-';
                    }
                })
                    .margin({ right: 5 });
            };

            Text().height(5);

            Row() {
                Button('1').width('23%').height(60).fontSize(24).onClick(() => {
                    this.appendToDisplay('1');
                })
                    .margin({ right: 5 });
                Button('2').width('23%').height(60).fontSize(24).onClick(() => {
                    this.appendToDisplay('2');
                })
                    .margin({ right: 5 });
                Button('3').width('23%').height(60).fontSize(24).onClick(() => {
                    this.appendToDisplay('3');
                })
                    .margin({ right: 5 });
                Button('+').width('23%').height(60).fontSize(24).onClick(() => {
                    this.performOperation('+');
                })
                    .margin({ right: 5 });
            };

            Text().height(5);

            Row() {
                Button('±').width('23%').height(60).fontSize(24).onClick(() => {
                    if (this.displayValue!== '') {
                        this.displayValue = (parseFloat(this.displayValue) * -1).toString();
                    }
                })
                    .margin({ right: 5 });
                Button('0').width('23%').height(60).fontSize(24).onClick(() => {
                    this.appendToDisplay('0');
                })
                    .margin({ right: 5 });
                Button('.').width('23%').height(60).fontSize(24).onClick(() => {
                    if (!this.displayValue.includes('.')) {
                        this.appendToDisplay('.');
                    }
                })
                    .margin({ right: 5 });
                Button('=').width('23%').height(60).fontSize(24).onClick(() => {
                    this.performEqual();
                    if (this.selectedMode === '程序员') {
                        this.updateAllBases(this.displayValue);
                    }
                })
                    .margin({ right: 5 });
            };

            if (this.selectedMode === '程序员') {
                Text('Binary: ' + this.binaryValue).margin({ top: 20 });
                Text('Octal: ' + this.octalValue).margin({ top: 10 });
                Text('Decimal: ' + this.decimalValue).margin({ top: 10 });
                Text('Hexadecimal: ' + this.hexadecimalValue).margin({ top: 10 });
            }
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
            let num1 = parseInt(this.firstOperand);
            let num2 = parseInt(this.displayValue);
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
                case '/':
                    if (num2!== 0) {
                        result = num1 / num2;
                    } else {
                        result = NaN;
                        this.displayValue = 'Error: Division by zero';
                        return;
                    }
                    break;
                 case '&':
                     result = num1 & num2;
                     break;
                 case '^':
                     result = num1 ^ num2;
                     break;
                 case '|':
                     result = num1 | num2;
                     break;
                default:
                    result = num1;
            }
            this.displayValue = result.toString();
            this.firstOperand = '';
            this.currentOperator = '';
            this.waitingForSecondOperand = false;

            this.updateAllBases(this.displayValue);
        }
    }



    performBitwiseOperation(operator: string) {
        if (this.displayValue !== '' && this.firstOperand !== '') {
            let num1 = parseInt(this.firstOperand, 10);
            let num2 = parseInt(this.displayValue, 10);
            let result: number;

            switch (operator) {
                case '&':
                    result = num1 & num2;
                    break;
                case '^':
                    result = num1 ^ num2;
                    break;
                case '|':
                    result = num1 | num2;
                    break;
            // You can add more cases for other bitwise operations if needed
                default:
                    return; // Exit if the operator is not recognized
            }

            this.displayValue = result.toString();
            this.firstOperand = ''; // Clear first operand after operation
            this.currentOperator = ''; // Clear operator
            this.waitingForSecondOperand = false; // Reset flag

            this.updateAllBases(this.displayValue); // Update bases
        }
    }


    leftShift(num: number): number {
        return num << 1;
    }

    rightShift(num: number): number {
        return num >> 1;
    }

    updateAllBases(value: string) {
        if (value!== '') {
            let decimalNumber = parseInt(value);
            this.binaryValue = decimalNumber.toString(2);
            this.octalValue = decimalNumber.toString(8);
            this.decimalValue = decimalNumber.toString();
            this.hexadecimalValue = decimalNumber.toString(16).toUpperCase();
        }
    }
}