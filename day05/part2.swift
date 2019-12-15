import Foundation

typealias InstructionIndex = Int

class Computer {
    enum Opcode: Int {
        enum Mode: Int {
            case position = 0
            case immediate = 1
        }
        
        case addition = 1
        case multiplication = 2
        case input = 3
        case output = 4
        case jumpIfTrue = 5
        case jumpIfFalse = 6
        case lessThan = 7
        case equals = 8
        case hcf = 99
    }
    
    enum Instruction {
        case addition(input: ((Int, Opcode.Mode), (Int, Opcode.Mode)), output: Int)
        case multiplication(input: ((Int, Opcode.Mode), (Int, Opcode.Mode)), output: Int)
        case input(output: Int)
        case output(input: (Int, Opcode.Mode))
        case jumpIfTrue(input: ((Int, Opcode.Mode), (Int, Opcode.Mode)))
        case jumpIfFalse(input: ((Int, Opcode.Mode), (Int, Opcode.Mode)))
        case lessThan(input: ((Int, Opcode.Mode), (Int, Opcode.Mode)), output: Int)
        case equals(input: ((Int, Opcode.Mode), (Int, Opcode.Mode)), output: Int)
        case hcf
    }
    
    private(set) var state: [Int]
    private(set) var outputs: [Int] = []
    
    private var instructionPointer = 0
    
    private let input: Int
    
    init(program: [Int], input: Int = 0) {
        self.state = program
        self.input = input
    }
    
    private func instruction(at index: Int) -> (instruction: Instruction, count: Int) {
        let opcodeWithModifiers = state[index]
        
        let opcode = opcodeWithModifiers % 100
        
        var modifiersAsStr = String((opcodeWithModifiers - opcode) / 100)
        
        while modifiersAsStr.count != 3 {
            modifiersAsStr = "0" + modifiersAsStr
        }
        
        let pmsTemp = (Int(String(modifiersAsStr.removeFirst()))!, Int(String(modifiersAsStr.removeFirst()))!, Int(String(modifiersAsStr.removeFirst()))!)
        let parameterModifiers = (Opcode.Mode(rawValue: pmsTemp.2)!, Opcode.Mode(rawValue: pmsTemp.1)!, Opcode.Mode(rawValue: pmsTemp.0)!)
        
        guard let parsedOpcode = Opcode(rawValue: opcode) else {
            fatalError("Unable to parse opcode - got '\(opcode)', which is an invalid code. Location")
        }
        
        switch parsedOpcode {
        case .addition:
            return (
                .addition(
                    input: ((state[index + 1], parameterModifiers.0), (state[index + 2], parameterModifiers.1)),
                    output: state[index + 3]
                ),
                4
            )
        case .multiplication:
            return (
                .multiplication(
                    input: ((state[index + 1], parameterModifiers.0), (state[index + 2], parameterModifiers.1)),
                    output: state[index + 3]
                ),
                4
            )
        case .input:
            return (
                .input(
                    output: state[index + 1]
                ),
                2
            )
        case .output:
            return (
                .output(
                    input: (state[index + 1], parameterModifiers.0)
                ),
                2
            )
        case .jumpIfTrue:
            return(
                .jumpIfTrue(
                    input: ((state[index + 1], parameterModifiers.0), (state[index + 2], parameterModifiers.1))
                ),
                3
            )
        case .jumpIfFalse:
            return(
                .jumpIfFalse(
                    input: ((state[index + 1], parameterModifiers.0), (state[index + 2], parameterModifiers.1))
                ),
                3
            )
        case .lessThan:
            return (
                .lessThan(
                    input: ((state[index + 1], parameterModifiers.0), (state[index + 2], parameterModifiers.1)),
                    output: state[index + 3]
                ),
                4
            )
        case .equals:
            return (
                .equals(
                    input: ((state[index + 1], parameterModifiers.0), (state[index + 2], parameterModifiers.1)),
                    output: state[index + 3]
                ),
                4
            )
        case .hcf:
            return (.hcf, 0)
        }
    }
    
    private func value(fromModeTuple modeTuple: (Int, Computer.Opcode.Mode)) -> Int {
        if modeTuple.1 == .immediate {
            return modeTuple.0
        } else {
            return state[modeTuple.0]
        }
    }
    
    func compute() -> Bool {
        let (instruction, count) = self.instruction(at: instructionPointer)
        
        instructionPointer += count
        
        return compute(instruction: instruction)
    }
    
    func compute(instruction: Instruction) -> Bool {
        switch instruction {
        case let .addition(input, output):
            let firstValue = value(fromModeTuple: input.0)
            let secondValue = value(fromModeTuple: input.1)
            
            state[output] = firstValue + secondValue
            
        case let .multiplication(input, output):
            let firstValue = value(fromModeTuple: input.0)
            let secondValue = value(fromModeTuple: input.1)
            
            state[output] = firstValue * secondValue
            
        case let .input(output):
            state[output] = self.input
            
        case let .output(input):
            outputs.append(value(fromModeTuple: input))
            
        case let .jumpIfTrue(input):
            if value(fromModeTuple: input.0) != 0 {
                instructionPointer = value(fromModeTuple: input.1)
            }
            
        case let .jumpIfFalse(input):
            if value(fromModeTuple: input.0) == 0 {
                instructionPointer = value(fromModeTuple: input.1)
            }
            
        case let .lessThan(input, output):
            let firstValue = value(fromModeTuple: input.0)
            let secondValue = value(fromModeTuple: input.1)
            
            state[output] = firstValue < secondValue ? 1 : 0
            
        case let .equals(input, output):
            let firstValue = value(fromModeTuple: input.0)
            let secondValue = value(fromModeTuple: input.1)
            
            state[output] = firstValue == secondValue ? 1 : 0
            
        case .hcf:
            return false
        }
        
        return true
        
    }
    
    func run() {
        while compute() {}
    }
}

//  Tests

func test(program: [Int], input: Int = 0, expectedState: [Int]? = nil, expectedOutput: [Int]? = nil) -> Bool {
    let testComputer = Computer(program: program, input: input)
    
    testComputer.run()
    
    if let es = expectedState, es != testComputer.state {
        return false
    }
    
    if let eo = expectedOutput, eo != testComputer.outputs {
        return false
    }
    
    return true
}

test(program: [1,0,0,0,99], expectedState: [2,0,0,0,99])
test(program: [2,3,0,3,99], expectedState: [2,3,0,6,99])
test(program: [2,4,4,5,99,0], expectedState: [2,4,4,5,99,9801])
test(program: [1,1,1,4,99,5,6,0,99], expectedState: [30,1,1,4,2,5,6,0,99])
test(program: [3,9,8,9,10,9,4,9,99,-1,8], input: 8, expectedOutput: [1])
test(program: [3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9], input: 0, expectedOutput: [0])
test(program: [3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9], input: 1, expectedOutput: [1])
test(program: [3,3,1105,-1,9,1101,0,0,12,4,12,99,1], input: 0, expectedOutput: [0])
test(program: [3,3,1105,-1,9,1101,0,0,12,4,12,99,1], input: 999999, expectedOutput: [1])
test(program: [3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,
               1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,
               999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99],
     input: 7,
     expectedOutput: [999])
test(program: [3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,
               1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,
               999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99],
    input: 8,
    expectedOutput: [1000])
test(program: [3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,
               1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,
               999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99],
    input: 9,
    expectedOutput: [1001])

//  Challenge

let initialInput = [
    3,225,1,225,6,6,1100,1,238,225,104,0,1101,40,27,224,101,-67,224,224,4,224,1002,223,8,223,1001,224,2,224,1,224,223,223,1101,33,38,225,1102,84,60,225,1101,65,62,225,1002,36,13,224,1001,224,-494,224,4,224,1002,223,8,223,1001,224,3,224,1,223,224,223,1102,86,5,224,101,-430,224,224,4,224,1002,223,8,223,101,6,224,224,1,223,224,223,1102,23,50,225,1001,44,10,224,101,-72,224,224,4,224,102,8,223,223,101,1,224,224,1,224,223,223,102,47,217,224,1001,224,-2303,224,4,224,102,8,223,223,101,2,224,224,1,223,224,223,1102,71,84,225,101,91,40,224,1001,224,-151,224,4,224,1002,223,8,223,1001,224,5,224,1,223,224,223,1101,87,91,225,1102,71,19,225,1,92,140,224,101,-134,224,224,4,224,1002,223,8,223,101,1,224,224,1,224,223,223,2,170,165,224,1001,224,-1653,224,4,224,1002,223,8,223,101,5,224,224,1,223,224,223,1101,49,32,225,4,223,99,0,0,0,677,0,0,0,0,0,0,0,0,0,0,0,1105,0,99999,1105,227,247,1105,1,99999,1005,227,99999,1005,0,256,1105,1,99999,1106,227,99999,1106,0,265,1105,1,99999,1006,0,99999,1006,227,274,1105,1,99999,1105,1,280,1105,1,99999,1,225,225,225,1101,294,0,0,105,1,0,1105,1,99999,1106,0,300,1105,1,99999,1,225,225,225,1101,314,0,0,106,0,0,1105,1,99999,1107,226,677,224,1002,223,2,223,1006,224,329,101,1,223,223,8,226,226,224,1002,223,2,223,1005,224,344,101,1,223,223,1007,677,226,224,102,2,223,223,1005,224,359,101,1,223,223,8,226,677,224,102,2,223,223,1005,224,374,101,1,223,223,1107,677,677,224,1002,223,2,223,1005,224,389,1001,223,1,223,108,226,677,224,102,2,223,223,1005,224,404,1001,223,1,223,108,677,677,224,1002,223,2,223,1006,224,419,101,1,223,223,107,677,677,224,102,2,223,223,1006,224,434,101,1,223,223,108,226,226,224,1002,223,2,223,1006,224,449,1001,223,1,223,8,677,226,224,1002,223,2,223,1005,224,464,101,1,223,223,1108,226,677,224,1002,223,2,223,1006,224,479,1001,223,1,223,1108,677,677,224,1002,223,2,223,1005,224,494,101,1,223,223,7,677,677,224,1002,223,2,223,1005,224,509,101,1,223,223,1007,677,677,224,1002,223,2,223,1005,224,524,101,1,223,223,7,677,226,224,1002,223,2,223,1005,224,539,101,1,223,223,1107,677,226,224,102,2,223,223,1006,224,554,101,1,223,223,107,226,677,224,1002,223,2,223,1005,224,569,101,1,223,223,107,226,226,224,1002,223,2,223,1005,224,584,101,1,223,223,1108,677,226,224,102,2,223,223,1006,224,599,1001,223,1,223,1008,677,677,224,102,2,223,223,1006,224,614,101,1,223,223,7,226,677,224,102,2,223,223,1005,224,629,101,1,223,223,1008,226,677,224,1002,223,2,223,1006,224,644,101,1,223,223,1007,226,226,224,1002,223,2,223,1005,224,659,1001,223,1,223,1008,226,226,224,102,2,223,223,1006,224,674,1001,223,1,223,4,223,99,226
]

let challengeComputer = Computer(program: initialInput, input: 5)

challengeComputer.run()

print("Diagnostic code: \(challengeComputer.outputs[0])")
