import router from '@ohos.router';


@Entry
@Component
struct Calculator {
    @State displayValue: string = '';
    @State currentOperator: string = '';
    @State firstOperand: string = '';
    @State waitingForSecondOperand: boolean = false;
    @State selectedMode: string = '科学';
    @State FunctionStr: string = '';
    @State FunctionMode: boolean = false;
    @State FunctionFini: boolean = false;
    @State expression: string = '';
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
                    if(this.FunctionMode && !this.FunctionFini){
                        this.displayValue += 'π';
                        this.displayValue = '(' + this.displayValue + ')';
                    } else this.displayValue = this.pi.toString();
                })
                    .margin({right: 5});
                Button('C').width('18%').height(60).fontSize(18).onClick(() => {
                    this.displayValue = '';
                    this.firstOperand = '';
                    this.currentOperator = '';
                    this.waitingForSecondOperand = false;
                    if(this.FunctionMode){
                        if(!this.FunctionFini){
                            this.displayValue = '';
                        }
                    }
                })
                    .margin({right: 5});
                Button('%').width('18%').height(60).fontSize(18).onClick(() => {
                    if(this.FunctionMode && !this.FunctionFini){
                        this.displayValue += '%'
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
                    if(this.FunctionMode)   {
                        this.displayValue += '/';
                    } else this.performOperation('/');
                })
                    .margin({right: 5});
            };
            Text().height(5);
            Row() {
                Button('e').width('18%').height(60).fontSize(18).onClick(() => {
                    if(this.FunctionMode && !this.FunctionFini) {
                        this.displayValue += 'e';
                        this.displayValue = '(' + this.e + ')';
                    } else this.displayValue = this.e.toString();
                })
                    .margin({right: 5});
                Button('√').width('18%').height(60).fontSize(18).onClick(() => {
                    if (this.FunctionMode && !this.FunctionFini){
                        this.displayValue = 'sqrt(' + this.displayValue + ')';
                    } else this.performScientificFunction('sqrt');
                })
                    .margin({right: 5});
                Button('log').width('18%').height(60).fontSize(18).onClick(() => {
                    if (this.FunctionMode && !this.FunctionFini){
                        this.displayValue = 'log10(' + this.displayValue + ')';
                    } else this.performScientificFunction('log');
                })
                    .margin({right: 5});
                Button('ln').width('18%').height(60).fontSize(18).onClick(() => {
                    if (this.FunctionMode && !this.FunctionFini){
                        this.displayValue = 'ln(' + this.displayValue + ')';
                    } else this.performScientificFunction('ln');
                })
                    .margin({right: 5});
                Button('^').width('18%').height(60).fontSize(18).onClick(() => {
                    if (this.FunctionMode && !this.FunctionFini){
                        this.displayValue += '^';
                    } else this.performOperation('^');
                })
                    .margin({right: 5});
            }
            Text().height(5);
            Row() {
                Button('mo').width('18%').height(60).fontSize(18).onClick(() => {
                    if (this.FunctionMode && !this.FunctionFini){
                        this.displayValue += '%';
                    } else this.performOperation('%');
                })
                    .margin({right: 5});
                Button('abs').width('18%').height(60).fontSize(18).onClick(()=>{
                    if (this.FunctionMode && !this.FunctionFini){
                        this.displayValue = 'abs(' + this.displayValue + ')';
                    } else this.performScientificFunction('abs');
                })
                    .margin({right: 5});
                Button('sin').width('18%').height(60).fontSize(18).onClick(()=>{
                    if (this.FunctionMode && !this.FunctionFini){
                        this.displayValue = 'sin(' + this.displayValue + ')';
                    } else this.performScientificFunction('sin');
                })
                    .margin({right: 5});
                Button('cos').width('18%').height(60).fontSize(18).onClick(()=>{
                    if (this.FunctionMode && !this.FunctionFini){
                        this.displayValue = 'cos(' + this.displayValue + ')';
                    } else this.performScientificFunction('cos');
                })
                    .margin({right: 5});
                Button('tan').width('18%').height(60).fontSize(18).onClick(()=>{
                    if (this.FunctionMode && !this.FunctionFini){
                        this.displayValue = 'tan(' + this.displayValue + ')';
                    } else this.performScientificFunction('tan');
                })
                    .margin({right: 5});
            }

            Text().height(5);

            Row() {
                Button('!').width('18%').height(60).fontSize(18).onClick(()=>{
                    if (this.FunctionMode && !this.FunctionFini){
                        this.displayValue = 'fac(' + this.displayValue + ')';
                    } else this.performScientificFunction('factorial');
                })
                    .margin({right: 5});
                Button('7').width('18%').height(60).fontSize(18).onClick(() => {
                    this.appendToDisplay('7');
                    if(this.FunctionMode && !this.FunctionFini)   this.displayValue = '(' + this.displayValue + ')';
                })
                    .margin({right: 5});
                Button('8').width('18%').height(60).fontSize(18).onClick(() => {
                    this.appendToDisplay('8');
                    if(this.FunctionMode && !this.FunctionFini)   this.displayValue = '(' + this.displayValue + ')';
                })
                    .margin({right: 5});
                Button('9').width('18%').height(60).fontSize(18).onClick(() => {
                    this.appendToDisplay('9');
                    if(this.FunctionMode && !this.FunctionFini)   this.displayValue = '(' + this.displayValue + ')';
                })
                    .margin({right: 5});
                Button('×').width('18%').height(60).fontSize(18).onClick(() => {
                    if (this.FunctionMode && !this.FunctionFini){
                        this.displayValue += '*';
                    } else this.performOperation('*');
                })
                    .margin({right: 5});
            };

            Text().height(5);

            Row() {
                Button('art').width('18%').height(60).fontSize(18).onClick(()=> {
                    if(this.FunctionMode && !this.FunctionFini){
                        this.displayValue = 'arctan(' + this.displayValue + ')';
                    } else this.performScientificFunction('arctan');
                })
                    .margin({right: 5});
                Button('4').width('18%').height(60).fontSize(18).onClick(() => {
                    this.appendToDisplay('4');
                    if(this.FunctionMode && !this.FunctionFini)   this.displayValue = '(' + this.displayValue + ')';
                })
                    .margin({right: 5});
                Button('5').width('18%').height(60).fontSize(18).onClick(() => {
                    this.appendToDisplay('5');
                    if(this.FunctionMode && !this.FunctionFini)   this.displayValue = '(' + this.displayValue + ')';
                })
                    .margin({right: 5});
                Button('6').width('18%').height(60).fontSize(18).onClick(() => {
                    this.appendToDisplay('6');
                    if(this.FunctionMode && !this.FunctionFini)   this.displayValue = '(' + this.displayValue + ')';
                })
                    .margin({right: 5});
                Button('-').width('18%').height(60).fontSize(18).onClick(() => {
                    if(this.FunctionMode && !this.FunctionFini){
                        this.displayValue += '-';
                        return;
                    }
                    if(this.displayValue!=='') this.performOperation('-');
                    else {
                        this.displayValue = '-';
                    }
                })
            };

            Text().height(5);

            Row() {
                Button('inv').width('18%').height(60).fontSize(18).onClick(()=>{
                    if(this.FunctionMode && !this.FunctionFini){
                        this.displayValue = 'inv(' + this.displayValue + ')';
                    } else this.performScientificFunction('inv');
                })
                    .margin({right: 5});
                Button('1').width('18%').height(60).fontSize(18).onClick(() => {
                    this.appendToDisplay('1');
                    if(this.FunctionMode && !this.FunctionFini)   this.displayValue = '(' + this.displayValue + ')';
                })
                    .margin({right: 5});
                Button('2').width('18%').height(60).fontSize(18).onClick(() => {
                    this.appendToDisplay('2');
                    if(this.FunctionMode && !this.FunctionFini)   this.displayValue = '(' + this.displayValue + ')';
                })
                    .margin({right: 5});
                Button('3').width('18%').height(60).fontSize(18).onClick(() => {
                    this.appendToDisplay('3');
                    if(this.FunctionMode && !this.FunctionFini)   this.displayValue = '(' + this.displayValue + ')';
                })
                    .margin({right: 5});
                Button('+').width('18%').height(60).fontSize(18).onClick(() => {
                    if(this.FunctionMode && !this.FunctionFini){
                        this.displayValue += '+' ;
                    } else this.performOperation('+');
                })
                    .margin({right: 5});
            };

            Text().height(5);

            Row() {
                Button('fun').width('18%').height(60).fontSize(18).onClick(()=>{
                    this.FunctionMode = !this.FunctionMode;
                    if(this.FunctionMode){
                        this.FunctionFini = false;
                        this.displayValue = 'x';
                    } else {
                        this.displayValue = '';
                    }
                })
                    .margin({right: 5});
                Button('±').width('18%').height(60).fontSize(18).onClick(() => {
                    if (this.displayValue !== '') {
                        this.displayValue = (parseFloat(this.displayValue) * -1).toString();
                    }
                    if (this.FunctionMode && !this.FunctionFini)  this.displayValue = '(0' + this.displayValue + ')';
                })
                    .margin({right: 5});
                Button('0').width('18%').height(60).fontSize(18).onClick(() => {
                    this.appendToDisplay('0');
                    if(this.FunctionMode && !this.FunctionFini)   this.displayValue = '(' + this.displayValue + ')';
                })
                    .margin({right: 5});
                Button('.').width('18%').height(60).fontSize(18).onClick(() => {
                    if (!this.displayValue.includes('.')) {
                        this.appendToDisplay('.');
                    }
                })
                    .margin({right: 5});
                Button('=').width('18%').height(60).fontSize(18).onClick(() => {
                    if(this.FunctionMode){
                      if(!this.FunctionFini)    {
                          this.FunctionFini = true;
                          this.FunctionStr = this.displayValue;
                          this.displayValue = 'f(x) = ' + this.displayValue;
                      }
                      else {
                          if(this.displayValue!=this.FunctionStr){
                              this.performEqual();
                              this.expression = this.FunctionStr.replace('x',this.displayValue);
                                this.calculate(this.expression);
                          }
                      }
                    } else this.performEqual();
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
        this.FunctionStr += str;
    }

    preInsert(str: string) {
        this.displayValue = str + '(' + this.displayValue + ')';
    }

    lstInsert(str: string){
        this.displayValue = '(' + this.displayValue + ')' + str;
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

    infixToPostfix(expression: string): string[] {
        const precedence = new Map<string, number>([
            ['+', 1],
            ['-', 1],
            ['*', 2],
            ['/', 2],
            ['%', 2],
            ['^', 3],
            ['sqrt', 3],
            ['log10', 3],
            ['ln', 3],
            ['sin', 3],
            ['cos', 3],
            ['tan', 3],
            ['arctan', 3],
            ['fac', 3],
            ['inv', 3],
            ['abs', 3]
        ])
        const output: string[] = []
        const operators: string[] = []
        const functions: Set<string> = new Set(['sqrt', 'log10', 'ln', 'sin', 'cos', 'tan'
            , 'inv', 'abs', 'fac', 'arctan'])

        let i = 0
        while (i < expression.length) {
            const token = expression[i]
            if (!isNaN(parseFloat(token)) || token === '.') {
                let num = token
                while (!isNaN(parseFloat(expression[i + 1])) || expression[i + 1] === '.') {
                    num += expression[++i]
                }
                output.push(num)
            } else if (token === '(') {
                operators.push(token)
            } else if (token === ')') {
                while (operators.length && operators[operators.length - 1] !== '(') {
                    output.push(operators.pop()!)
                }
                operators.pop()
                if (operators.length && functions.has(operators[operators.length - 1])) {
                    output.push(operators.pop()!)
                }
            } else if (functions.has(expression.slice(i, i+6)) || functions.has(expression.slice(i, i + 5)) || functions.has(expression.slice(i, i + 4)) || functions.has(expression.slice(i, i + 3)) || functions.has(expression.slice(i, i + 2))) {
                let func = ''
                if(functions.has(expression.slice(i, i + 6))){
                    func = expression.slice(i, i + 6)
                    i += 5
                } else if (functions.has(expression.slice(i, i + 5))) {
                    func = expression.slice(i, i + 5)
                    i += 4
                } else if (functions.has(expression.slice(i, i + 4))) {
                    func = expression.slice(i, i + 4)
                    i += 3
                } else if (functions.has(expression.slice(i, i + 3))){
                    func = expression.slice(i, i + 3)
                    i += 2
                } else {
                    func = expression.slice(i, i + 2)
                    i += 1
                }
                operators.push(func)
            } else if (precedence.has(token)) {
                while (operators.length && precedence.get(operators[operators.length - 1])! >= precedence.get(token)!) {
                    output.push(operators.pop()!)
                }
                operators.push(token)
            }
            i++
        }

        while (operators.length) {
            output.push(operators.pop()!)
        }

        return output
    }

    evaluatePostfix(postfix: string[]): number {
        const stack: number[] = []

        postfix.forEach(token => {
            if (token === 'e' ) {
                stack.push(Math.E)
            } else if(token === 'π') {
                stack.push(Math.PI)
            } else if (!isNaN(parseFloat(token))) {
                stack.push(parseFloat(token))
            } else if (token === '+') {
                stack.push(stack.pop()! + stack.pop()!)
            } else if (token === '-') {
                const b = stack.pop()!
                const a = stack.pop()!
                stack.push(a - b)
            } else if (token === '%') {
                stack.push(stack.pop()! % stack.pop()!)
            } else if (token === '*') {
                stack.push(stack.pop()! * stack.pop()!)
            } else if (token === '/') {
                const b = stack.pop()!
                const a = stack.pop()!
                stack.push(a / b)
            } else if (token === '^') {
                const b = stack.pop()!
                const a = stack.pop()!
                stack.push(Math.pow(a, b))
            } else if (token === 'sqrt') {
                stack.push(Math.sqrt(stack.pop()!))
            } else if (token === 'log10') {
                stack.push(Math.log10(stack.pop()!))
            } else if (token === 'ln') {
                stack.push(Math.log(stack.pop()!));
            } else if (token === 'sin'){
                stack.push(Math.sin(stack.pop()!))
            } else if (token === 'cos'){
                stack.push(Math.cos(stack.pop()!))
            } else if (token === 'tan') {
                stack.push(Math.tan(stack.pop()!))
            } else if (token === 'arctan') {
                stack.push(Math.atan(stack.pop()!))
            } else if (token === 'abs') {
                stack.push(Math.abs(stack.pop()!))
            } else if (token === 'fac') {
                stack.push(this.factorial(stack.pop()!))
            } else if (token === 'inv') {
                stack.push(1 / stack.pop()!)
            }
        });

        return stack.pop()!;
    }

    factorial(n: number): number {
        if (n <= 0) {
            return 1;
        } else {
            return n * this.factorial(n - 1);
        }
    }

    calculate(expression: string) {
        try {
            const postfix = this.infixToPostfix(expression)
            const result = this.evaluatePostfix(postfix)
            this.displayValue = result.toString()

        } catch (e) {
            this.displayValue = 'Error'
        }
    }

}