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
            case relative = 2
        }
        
        case addition = 1
        case multiplication = 2
        case input = 3
        case output = 4
        case jumpIfTrue = 5
        case jumpIfFalse = 6
        case lessThan = 7
        case equals = 8
        case adjustRelativeBase = 9
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
        case adjustRelativeBase(input: (Int, Opcode.Mode))
        case hcf
    }
    
    private(set) var state: [Int]
    public private(set) var outputs: [Int] = []
    
    private var instructionPointer = 0
    private var relativeBase = 0
    public var nextInput: Int? = nil
    
    public init(program: [Int]) {
        self.state = program
    }
    
    private func getState(at index: Int) -> Int {
        guard index < state.count else {
            return 0
        }
        
        return state[index]
    }
    
    private func setState(at index: Int, value: Int) {
        while index > (state.count - 1) {
            state.append(0)
        }
        
        state[index] = value
    }
    
    private func getOutputIndex(pointer: Int, mode: Opcode.Mode) -> Int {
        switch mode {
        case .immediate:
            fatalError("Can't output to an immediate value!")
            
        case .position:
            return getState(at: pointer)
            
        case .relative:
            return getState(at: pointer) + relativeBase
        }
    }
    
    private func instruction(at index: Int) -> (instruction: Instruction, count: Int) {
        let opcodeWithModifiers = getState(at: index)
        
        let opcode = opcodeWithModifiers % 100
        
        let modifiers = (opcodeWithModifiers - opcode) / 100
        
        let parameterModifiers = (Opcode.Mode(rawValue: modifiers % 10)!,
                                  Opcode.Mode(rawValue: ((modifiers % 100) - (modifiers % 10)) / 10)!,
                                  Opcode.Mode(rawValue: (modifiers - (modifiers % 10) - ((modifiers % 100) - (modifiers % 10))) / 100)!)
        
        guard let parsedOpcode = Opcode(rawValue: opcode) else {
            print("=== Parse Error, CPU Halted! ===")
            print("Current state: \(state)")
            print("Current index: \(index)")
            print("Current opcode: \(opcodeWithModifiers)")
            print("Current parameter modifiers: \(parameterModifiers.0), \(parameterModifiers.1), \(parameterModifiers.2)")
            print("---")
            fatalError("Unable to parse opcode - got '\(opcode)', which is an invalid code. Location")
        }
        
        switch parsedOpcode {
        case .addition:
            return (
                .addition(
                    input: ((getState(at: index + 1), parameterModifiers.0), (getState(at: index + 2), parameterModifiers.1)),
                    output: getOutputIndex(pointer: index + 3, mode: parameterModifiers.2)
                ),
                4
            )
        case .multiplication:
            return (
                .multiplication(
                    input: ((getState(at: index + 1), parameterModifiers.0), (getState(at: index + 2), parameterModifiers.1)),
                    output: getOutputIndex(pointer: index + 3, mode: parameterModifiers.2)
                ),
                4
            )
        case .input:
            return (
                .input(
                    output: getOutputIndex(pointer: index + 1, mode: parameterModifiers.0)
                ),
                2
            )
        case .output:
            return (
                .output(
                    input: (getState(at: index + 1), parameterModifiers.0)
                ),
                2
            )
        case .jumpIfTrue:
            return(
                .jumpIfTrue(
                    input: ((getState(at: index + 1), parameterModifiers.0), (getState(at: index + 2), parameterModifiers.1))
                ),
                3
            )
        case .jumpIfFalse:
            return(
                .jumpIfFalse(
                    input: ((getState(at: index + 1), parameterModifiers.0), (getState(at: index + 2), parameterModifiers.1))
                ),
                3
            )
        case .lessThan:
            return (
                .lessThan(
                    input: ((getState(at: index + 1), parameterModifiers.0), (getState(at: index + 2), parameterModifiers.1)),
                    output: getOutputIndex(pointer: index + 3, mode: parameterModifiers.2)
                ),
                4
            )
        case .equals:
            return (
                .equals(
                    input: ((getState(at: index + 1), parameterModifiers.0), (getState(at: index + 2), parameterModifiers.1)),
                    output: getOutputIndex(pointer: index + 3, mode: parameterModifiers.2)
                ),
                4
            )
        case .adjustRelativeBase:
            return (
                .adjustRelativeBase(
                    input: (getState(at: index + 1), parameterModifiers.0)
                ),
                2
            )
        case .hcf:
            return (.hcf, 0)
        }
    }
    
    private func value(fromModeTuple modeTuple: (Int, Computer.Opcode.Mode)) -> Int {
        switch modeTuple.1 {
        case .immediate:
            return modeTuple.0
            
        case .position:
            return getState(at: modeTuple.0)
            
        case .relative:
            return getState(at: modeTuple.0 + relativeBase)
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
            
            setState(at: output, value: firstValue + secondValue)
            
            canContinue = true
            
        case let .multiplication(input, output):
            let firstValue = value(fromModeTuple: input.0)
            let secondValue = value(fromModeTuple: input.1)
            
            setState(at: output, value: firstValue * secondValue)
            
            canContinue = true
            
        case let .input(output):
            if let nextInput = self.nextInput {
                setState(at: output, value: nextInput)
                
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
            
            setState(at: output, value: firstValue < secondValue ? 1 : 0)
            
            canContinue = true
            
        case let .equals(input, output):
            let firstValue = value(fromModeTuple: input.0)
            let secondValue = value(fromModeTuple: input.1)
            
            setState(at: output, value: firstValue == secondValue ? 1 : 0)
            
            canContinue = true
            
        case let .adjustRelativeBase(input):
            relativeBase += value(fromModeTuple: input)
            
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
