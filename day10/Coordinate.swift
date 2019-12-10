import Foundation

public struct Coordinate: Equatable {
    public let x: Double
    public let y: Double
    
    public init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
    
    func vector(to otherCoordinate: Coordinate) -> Coordinate {
        return Coordinate(x: otherCoordinate.x - x, y: otherCoordinate.y - y)
    }
    
    public func stepIncrease(to otherCoordinate: Coordinate) -> Coordinate {
        let bigVector = vector(to: otherCoordinate)
        
        var normalizedVector: Coordinate
        
        if abs(bigVector.x) > abs(bigVector.y) {
            normalizedVector = Coordinate(x: 1, y: bigVector.y / bigVector.x)
        } else if abs(bigVector.x) < abs(bigVector.y) {
            normalizedVector = Coordinate(x: bigVector.x / bigVector.y, y: 1)
        } else {
            normalizedVector = Coordinate(x: 1, y: 1)
        }
        
        if bigVector.x > 0 && normalizedVector.x < 0 ||
            bigVector.x < 0 && normalizedVector.x > 0 {
            
            normalizedVector = Coordinate(x: normalizedVector.x * -1, y: normalizedVector.y)
        }
        
        if bigVector.y > 0 && normalizedVector.y < 0 ||
            bigVector.y < 0 && normalizedVector.y > 0 {
            
            normalizedVector = Coordinate(x: normalizedVector.x, y: normalizedVector.y * -1)
        }
        
        return normalizedVector
    }
    
    public static func + (left: Coordinate, right: Coordinate) -> Coordinate {
        return Coordinate(x: left.x + right.x, y: left.y + right.y)
    }
}
