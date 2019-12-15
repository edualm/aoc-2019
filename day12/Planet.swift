import Foundation

public struct Planet {
    
    public private(set) var moons: [Moon]
    
    let pairs: [[Int]]
    
    public init(moons: [Moon]) {
        self.moons = moons
        
        var p: [[Int]] = []
        
        for m1 in 0...(moons.count - 1) {
            for m2 in 0...(moons.count - 1) {
                guard m1 != m2 && !p.contains([m1, m2]) && !p.contains([m2, m1]) else {
                    continue
                }
                
                p.append([m1, m2])
            }
        }
        
        self.pairs = p
    }
    
    public mutating func step() {
        for pair in pairs {
            if moons[pair[0]].position.x > moons[pair[1]].position.x {
                moons[pair[0]].velocity = XYZ(moons[pair[0]].velocity.x - 1, moons[pair[0]].velocity.y, moons[pair[0]].velocity.z)
                moons[pair[1]].velocity = XYZ(moons[pair[1]].velocity.x + 1, moons[pair[1]].velocity.y, moons[pair[1]].velocity.z)
            } else if moons[pair[0]].position.x < moons[pair[1]].position.x {
                moons[pair[0]].velocity = XYZ(moons[pair[0]].velocity.x + 1, moons[pair[0]].velocity.y, moons[pair[0]].velocity.z)
                moons[pair[1]].velocity = XYZ(moons[pair[1]].velocity.x - 1, moons[pair[1]].velocity.y, moons[pair[1]].velocity.z)
            }
            
            if moons[pair[0]].position.y > moons[pair[1]].position.y {
                moons[pair[0]].velocity = XYZ(moons[pair[0]].velocity.x, moons[pair[0]].velocity.y - 1, moons[pair[0]].velocity.z)
                moons[pair[1]].velocity = XYZ(moons[pair[1]].velocity.x, moons[pair[1]].velocity.y + 1, moons[pair[1]].velocity.z)
            } else if moons[pair[0]].position.y < moons[pair[1]].position.y {
                moons[pair[0]].velocity = XYZ(moons[pair[0]].velocity.x, moons[pair[0]].velocity.y + 1, moons[pair[0]].velocity.z)
                moons[pair[1]].velocity = XYZ(moons[pair[1]].velocity.x, moons[pair[1]].velocity.y - 1, moons[pair[1]].velocity.z)
            }
            
            if moons[pair[0]].position.z > moons[pair[1]].position.z {
                moons[pair[0]].velocity = XYZ(moons[pair[0]].velocity.x, moons[pair[0]].velocity.y, moons[pair[0]].velocity.z - 1)
                moons[pair[1]].velocity = XYZ(moons[pair[1]].velocity.x, moons[pair[1]].velocity.y, moons[pair[1]].velocity.z + 1)
            } else if moons[pair[0]].position.z < moons[pair[1]].position.z {
                moons[pair[0]].velocity = XYZ(moons[pair[0]].velocity.x, moons[pair[0]].velocity.y, moons[pair[0]].velocity.z + 1)
                moons[pair[1]].velocity = XYZ(moons[pair[1]].velocity.x, moons[pair[1]].velocity.y, moons[pair[1]].velocity.z - 1)
            }
        }
        
        for idx in 0...(moons.count - 1) {
            moons[idx].applyVelocity()
        }
    }
    
    public mutating func reset() {
        for i in 0...(moons.count - 1) {
            moons[i].reset()
        }
    }
}
