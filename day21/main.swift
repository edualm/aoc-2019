import Foundation

let part1 = [
    "OR A J",
    "AND B J",
    "AND C J",
    "NOT J J",
    "AND D J",
    "WALK"
]

let part2 = [
    "OR A J",
    "AND B J",
    "AND C J",
    "NOT J J",
    "AND D J",
    "OR E T",
    "OR H T",
    "AND T J",
    "RUN"
]

func calculate(with instructions: [String]) -> Int {
    let computer = Computer(program: Input)
    
    instructions.forEach { computer.run(withString: $0) }
    
    return computer.outputs.last!
}

print("Part 1 answer: \(calculate(with: part1))")
print("Part 2 answer: \(calculate(with: part2))")
