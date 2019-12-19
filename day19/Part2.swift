import Foundation

//  Setting it to (3, 4) as I know that's a good starting point
//  from what I saw in Part 1... But it could be automated.

public func calculatePart2(input: [Int]) -> (x: Int, y: Int) {
    for y in (4...) {
        var foundAtCurrentRow = false
        
        var startingX = 3
        
        for x in (startingX...) {
            let currentValue = output(for: (x, y), using: input)
            
            if currentValue == 0 && foundAtCurrentRow {
                break
            } else if currentValue == 1 {
                if !foundAtCurrentRow {
                    foundAtCurrentRow = true
                    startingX = x
                }
                
                if output(for: (x: x + 99, y: y), using: input) == 1 &&
                    output(for: (x: x, y: y + 99), using: input) == 1 &&
                    output(for: (x: x + 99, y: y + 99), using: input) == 1 {
                    return (x, y)
                }
            }
        }
    }
    
    fatalError("This can never be reached!")
}
