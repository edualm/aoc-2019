import Foundation

public struct Moon: Equatable, CustomStringConvertible {
    
    public var position: XYZ
    public var velocity: XYZ
    
    private let originalPosition: XYZ
    
    public var description: String {
        return "pos=<x=\(position.x), y= \(position.y), z=\(position.z)>, vel=<x=\(velocity.x), y= \(velocity.y), z=\(velocity.z)>"
    }
    
    public static func == (lhs: Moon, rhs: Moon) -> Bool {
        return lhs.position.x == rhs.position.x &&
            lhs.position.y == rhs.position.y &&
            lhs.position.z == rhs.position.z &&
            lhs.velocity.x == rhs.velocity.x &&
            lhs.velocity.y == rhs.velocity.y &&
            lhs.velocity.z == rhs.velocity.z
    }
    
    public init(position: XYZ, velocity: XYZ = XYZ(x: 0, y: 0, z: 0)) {
        self.position = position
        self.velocity = velocity
        
        self.originalPosition = position
    }
    
    mutating public func applyVelocity() {
        position = XYZ(x: position.x + velocity.x,
                       y: position.y + velocity.y,
                       z: position.z + velocity.z)
    }
    
    mutating public func reset() {
        self.position = originalPosition
        self.velocity = XYZ(0, 0, 0)
    }
    
    public var potentialEnergy: Int {
        return abs(position.x) + abs(position.y) + abs(position.z)
    }
    
    public var kineticEnergy: Int {
        return abs(velocity.x) + abs(velocity.y) + abs(velocity.z)
    }
    
    public var energy: Int {
        return potentialEnergy * kineticEnergy
    }
}
