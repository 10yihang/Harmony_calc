@Entry
@Component
struct Index {
    @State expression: string = ''
    @State result: string = ''

    build() {
        Column() {
            Text('Expression:')
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .margin({top: 20})

            TextInput({placeholder: 'Enter expression'})
                .onChange((value: string) => {
                    this.expression = value
                })
                .width('100%')
                .fontSize(20)
                .padding(10)
                .margin({top: 10})

            Button('Calculate')
                .onClick(() => this.calculate())
                .width('100%').height(50).fontSize(20)
                .margin({top: 20})

            Text('Result: ' + this.result)
                .fontSize(20)
                .margin({top: 20})
        }
        .padding(20)
    }

    infixToPostfix(expression: string): string[] {
        const precedence = new Map<string, number>([
            ['+', 1],
            ['-', 1],
            ['*', 2],
            ['/', 2],
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
            console.log('Token:', token)
            if (!isNaN(parseFloat(token))) {
                stack.push(parseFloat(token))
            } else if (token === '+') {
                stack.push(stack.pop()! + stack.pop()!)
            } else if (token === '-') {
                const b = stack.pop()!
                const a = stack.pop()!
                stack.push(a - b)
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

    calculate() {
        try {
            const postfix = this.infixToPostfix(this.expression)
            const result = this.evaluatePostfix(postfix)
            this.result = result.toString()
        } catch (e) {
            this.result = 'Error'
        }
    }
}
