import Foundation

public struct Coordinate2D: Hashable {
    public let x: Int
    public let y: Int
    
    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    public init(_ x: Int, _ y: Int) {
        self.init(x: x, y: y)
    }
    
    public var hashValue: Int {
        return x.hashValue ^ y.hashValue
    }
    
    static public func == (lhs: Coordinate2D, rhs: Coordinate2D) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}
