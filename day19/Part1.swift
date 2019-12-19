import Foundation

public func calculatePart1(input: [Int]) -> Int {
    var points = 0
    
    for x in (0...49) {
        for y in (0...49) {
            points += output(for: (x, y), using: input)
        }
    }
    
    return points
}
