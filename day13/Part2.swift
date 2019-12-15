import Foundation

public func part2(input: inout [Int]) -> [Int] {
    input[0] = 2
    
    let computer = Computer(program: input)
    
    var paddleCoordinate: Coordinate!
    var ballCoordinate: Coordinate!
    
    func calculatePositions() {
        for i in 0...((computer.outputs.count - 1) / 3) {
            let currentIndex = i * 3
            
            if computer.outputs[currentIndex + 2] == 3 {
                paddleCoordinate = Coordinate(x: computer.outputs[currentIndex],
                                              y: computer.outputs[currentIndex + 1])
            }
            
            if computer.outputs[currentIndex + 2] == 4 {
                ballCoordinate = Coordinate(x: computer.outputs[currentIndex],
                                            y: computer.outputs[currentIndex + 1])
            }
        }
    }
    
    while computer.run() != .finished {
        calculatePositions()
        
        if ballCoordinate.x == paddleCoordinate.x {
            computer.nextInput = 0
        } else if ballCoordinate.x > paddleCoordinate.x {
            computer.nextInput = 1
        } else {
            computer.nextInput = -1
        }
    }
    
    return computer.outputs
}
