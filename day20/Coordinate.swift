import Foundation

public struct Coordinate {
    public let x: Int
    public let y: Int
    
    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    public static func + (left: Coordinate, right: Coordinate) -> Coordinate {
        return Coordinate(x: left.x + right.x, y: left.y + right.y)
    }
}

extension Coordinate: Hashable {
    public var hashValue: Int {
        return x.hashValue ^ y.hashValue
    }
    
    static public func == (lhs: Coordinate, rhs: Coordinate) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}
