import Foundation

public class Computer {
    public enum ComputationState {
        case waitingForInput
        case finished
    }
    
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
    public private(set) var outputs: [Int] = []
    
    private var instructionPointer = 0
    public var nextInput: Int? = nil
    
    public init(program: [Int]) {
        self.state = program
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
    
    func compute() -> (canContinue: Bool, currentInstruction: Instruction) {
        let (instruction, count) = self.instruction(at: instructionPointer)
        
        let previousInstructionPointer = instructionPointer
        
        let ret = compute(instruction: instruction)
        
        if ret.canContinue && previousInstructionPointer == instructionPointer {
            instructionPointer += count
        }
        
        return ret
    }
    
    func compute(instruction: Instruction) -> (canContinue: Bool, currentInstruction: Instruction) {
        let canContinue: Bool
        
        switch instruction {
        case let .addition(input, output):
            let firstValue = value(fromModeTuple: input.0)
            let secondValue = value(fromModeTuple: input.1)
            
            state[output] = firstValue + secondValue
            
            canContinue = true
            
        case let .multiplication(input, output):
            let firstValue = value(fromModeTuple: input.0)
            let secondValue = value(fromModeTuple: input.1)
            
            state[output] = firstValue * secondValue
            
            canContinue = true
            
        case let .input(output):
            if let nextInput = self.nextInput {
                state[output] = nextInput
                
                self.nextInput = nil
                
                canContinue = true
            } else {
                canContinue = false
            }
            
        case let .output(input):
            outputs.append(value(fromModeTuple: input))
            
            canContinue = true
            
        case let .jumpIfTrue(input):
            if value(fromModeTuple: input.0) != 0 {
                instructionPointer = value(fromModeTuple: input.1)
            }
            
            canContinue = true
            
        case let .jumpIfFalse(input):
            if value(fromModeTuple: input.0) == 0 {
                instructionPointer = value(fromModeTuple: input.1)
            }
            
            canContinue = true
            
        case let .lessThan(input, output):
            let firstValue = value(fromModeTuple: input.0)
            let secondValue = value(fromModeTuple: input.1)
            
            state[output] = firstValue < secondValue ? 1 : 0
            
            canContinue = true
            
        case let .equals(input, output):
            let firstValue = value(fromModeTuple: input.0)
            let secondValue = value(fromModeTuple: input.1)
            
            state[output] = firstValue == secondValue ? 1 : 0
            
            canContinue = true
            
        case .hcf:
            canContinue = false
        }
        
        return (canContinue, instruction)
        
    }
    
    public func run() -> ComputationState {
        while true {
            let cs = compute()
            
            if !cs.canContinue {
                switch cs.currentInstruction {
                case .hcf:
                    return .finished
                default:
                    return .waitingForInput
                }
            }
        }
    }
}

