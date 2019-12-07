import Foundation

struct Amplifier {
    private let computer: Computer
    private var initialInputs: [Int]
    
    init(phaseSetting: Int, program: [Int], initialInput: Int) {
        self.initialInputs = [phaseSetting, initialInput]
        
        self.computer = Computer(program: program)
    }
    
    @discardableResult func initialRun() -> Computer.ComputationState {
        run(input: initialInputs[0])
        return run(input: initialInputs[1])
    }
    
    func run(input: Int?) -> Computer.ComputationState {
        if let i = input {
            self.computer.nextInput = i
        }
        
        return self.computer.run()
    }
    
    var output: Int {
        return self.computer.outputs[self.computer.outputs.count - 1]
    }
}

enum Mode {
    case normal
    case feedbackLoop
    
    var possiblePhaseSettings: [Int] {
        switch self {
        case .normal:
            return [0, 1, 2, 3, 4]
        case .feedbackLoop:
            return [5, 6, 7, 8, 9]
        }
    }
}

func calculate(program: [Int], mode: Mode) -> (signal: Int, sequence: [Int]) {
    var maxCalculatedSignal: (signal: Int, sequence: [Int])? = nil

    let allPossiblePhaseSequences = permutations(mode.possiblePhaseSettings)

    for seq in allPossiblePhaseSequences {
        var amplifiers: [Amplifier] = []
        
        for i in 0...4 {
            let lastAmplifierOutput = i > 0 ? amplifiers[i - 1].output : 0
            
            let amp = Amplifier(phaseSetting: seq[i], program: program, initialInput: lastAmplifierOutput)
            
            amp.initialRun()
            
            amplifiers.append(amp)
        }
        
        var halted = false
        
        while !halted {
            for i in 0...4 {
                var previousAmplifierIndex = i - 1
                
                if previousAmplifierIndex < 0 {
                    previousAmplifierIndex = 4
                }
                
                let previousAmplifier = amplifiers[previousAmplifierIndex]
                let currentAmplifier = amplifiers[i]
                
                if currentAmplifier.run(input: nil) == .waitingForInput {
                    currentAmplifier.run(input: previousAmplifier.output)
                } else {
                    halted = true
                }
            }
        }
        
        if maxCalculatedSignal == nil || maxCalculatedSignal!.0 < amplifiers.last!.output {
            maxCalculatedSignal = (amplifiers.last!.output, seq)
        }
    }
    
    return maxCalculatedSignal!
}

//  Tests!

guard calculate(program: [3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0], mode: .normal) == (43210, [4,3,2,1,0]) else {
    fatalError("Part 1, Test 1 failed!")
}

guard calculate(program: [3,23,3,24,1002,24,10,24,1002,23,-1,23,
101,5,23,23,1,24,23,23,4,23,99,0,0], mode: .normal) == (54321, [0,1,2,3,4]) else {
    fatalError("Part 1, Test 2 failed!")
}

guard calculate(program: [3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,
1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0], mode: .normal) == (65210, [1,0,4,3,2]) else {
    fatalError("Part 1, Test 3 failed!")
}

guard calculate(program: [3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,
27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5], mode: .feedbackLoop) == (139629729, [9,8,7,6,5]) else {
    fatalError("Part 2, Test 1 failed!")
}

guard calculate(program: [3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,
-5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,
53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10], mode: .feedbackLoop) == (18216, [9,7,8,5,6]) else {
    fatalError("Part 2, Test 2 failed!")
}

//  Challenge!

calculate(program: [3,8,1001,8,10,8,105,1,0,0,21,42,67,88,105,114,195,276,357,438,99999,3,9,101,4,9,9,102,3,9,9,1001,9,2,9,102,4,9,9,4,9,99,3,9,1001,9,4,9,102,4,9,9,101,2,9,9,1002,9,5,9,1001,9,2,9,4,9,99,3,9,1001,9,4,9,1002,9,4,9,101,2,9,9,1002,9,2,9,4,9,99,3,9,101,4,9,9,102,3,9,9,1001,9,5,9,4,9,99,3,9,102,5,9,9,4,9,99,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,1,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,99,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,1,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,99
], mode: .normal)

calculate(program: [3,8,1001,8,10,8,105,1,0,0,21,42,67,88,105,114,195,276,357,438,99999,3,9,101,4,9,9,102,3,9,9,1001,9,2,9,102,4,9,9,4,9,99,3,9,1001,9,4,9,102,4,9,9,101,2,9,9,1002,9,5,9,1001,9,2,9,4,9,99,3,9,1001,9,4,9,1002,9,4,9,101,2,9,9,1002,9,2,9,4,9,99,3,9,101,4,9,9,102,3,9,9,1001,9,5,9,4,9,99,3,9,102,5,9,9,4,9,99,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,1,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,99,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,1,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,99
], mode: .feedbackLoop)
