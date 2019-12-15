import Foundation

public struct XYZ: Hashable {
    public let x: Int
    public let y: Int
    public let z: Int
    
    public init (_ x: Int, _ y: Int, _ z: Int) {
        self.init(x: x, y: y, z: z)
    }
    
    public init(x: Int, y: Int, z: Int) {
        self.x = x
        self.y = y
        self.z = z
    }
}
