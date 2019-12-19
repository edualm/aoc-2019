import Foundation

public func output(for coordinate: (x: Int, y: Int), using input: [Int]) -> Int {
    let computer = Computer(program: input)
    
    computer.nextInput = coordinate.x
    
    computer.run()
    
    computer.nextInput = coordinate.y
    
    computer.run()
    
    return computer.outputs[0]
}
