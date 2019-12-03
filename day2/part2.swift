import UIKit

typealias InstructionIndex = Int

class Computer {
    enum Opcode: Int {
        case addition = 1
        case multiplication = 2
        case hcf = 99
    }
    
    struct Instruction {
        let opcode: Opcode
        let inputIndexes: (Int, Int)
        let outputIndex: Int
    }
    
    private(set) var state: [Int] = []
    private var currentInstructionIndex = 0
    
    init() {
        
    }
    
    init(input: [Int]) {
        state = input
    }
    
    var currentInstruction: Instruction? {
        return instruction(at: currentInstructionIndex)
    }
    
    private func instruction(at index: Int) -> Instruction? {
        if state[index * 4] == Opcode.hcf.rawValue {
            return nil
        }
        
        return Instruction(opcode: Opcode(rawValue: state[index * 4])!,
                           inputIndexes: (state[index * 4 + 1],
                                          state[index * 4 + 2]),
                           outputIndex: state[index * 4 + 3])
    }
    
    func compute() -> Bool {
        return compute(input: &state)
    }
    
    func compute(input: inout [Int]) -> Bool {
        guard let instruction = self.instruction(at: currentInstructionIndex) else {
            return false
        }
        
        currentInstructionIndex = currentInstructionIndex + 1
        
        return compute(input: &state, instruction: instruction)
    }
    
    func compute(input: inout [Int], instruction: Instruction) -> Bool {
        switch instruction.opcode {
        case .addition:
            state[instruction.outputIndex] = state[instruction.inputIndexes.0] + state[instruction.inputIndexes.1]
        case .multiplication:
            state[instruction.outputIndex] = state[instruction.inputIndexes.0] * state[instruction.inputIndexes.1]
        case .hcf:
            return false
        }
        
        return true
    }
    
    func run() {
        while compute() {}
    }
}

//  Test 1

let testComputer1 = Computer(input: [1,0,0,0,99])

testComputer1.run()

testComputer1.state == [2,0,0,0,99]

//  Test 2

let testComputer2 = Computer(input: [2,3,0,3,99])

testComputer2.run()

testComputer2.state == [2,3,0,6,99]

//  Test 3

let testComputer3 = Computer(input: [2,4,4,5,99,0])

testComputer3.run()

testComputer3.state == [2,4,4,5,99,9801]

//  Test 4

let testComputer4 = Computer(input: [1,1,1,4,99,5,6,0,99])

testComputer4.run()

testComputer4.state == [30,1,1,4,2,5,6,0,99]

//  Challenge

let initialInput = [
    1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,6,1,19,1,19,10,23,2,13,23,27,1,5,27,31,2,6,31,35,1,6,35,39,2,39,9,43,1,5,43,47,1,13,47,51,1,10,51,55,2,55,10,59,2,10,59,63,1,9,63,67,2,67,13,71,1,71,6,75,2,6,75,79,1,5,79,83,2,83,9,87,1,6,87,91,2,91,6,95,1,95,6,99,2,99,13,103,1,6,103,107,1,2,107,111,1,111,9,0,99,2,14,0,0
]

var answer: (Int, Int)? = nil

for i in 0...99 {
    guard answer == nil else { break }
    
    for j in 0...99 {
        guard answer == nil else { break }
        
        var input = initialInput
        
        input[1] = i
        input[2] = j
        
        let computer = Computer(input: input)
        
        computer.run()
        
        if computer.state[0] == 19690720 {
            answer = (i, j)
        }
    }
}

if let answer = answer {
    100 * answer.0 + answer.1
}

