import Foundation

public func findPart2Solution(planet: inout Planet) -> Int {
    planet.reset()
    
    let originalMoons = planet.moons
    
    var steps = (0, 0, 0)
    
    while true {
        planet.step()
        
        steps.0 += 1
        
        var allMatch = true
        
        for i in 0...(originalMoons.count - 1) {
            if planet.moons[i].position.x != originalMoons[i].position.x && planet.moons[i].velocity.x != originalMoons[i].velocity.x {
                allMatch = false
                
                break
            }
        }
        
        if allMatch {
            break
        }
    }
    
    planet.reset()
    
    while true {
        planet.step()
        
        steps.1 += 1
        
        var allMatch = true
        
        for i in 0...(originalMoons.count - 1) {
            if planet.moons[i].position.y != originalMoons[i].position.y && planet.moons[i].velocity.y != originalMoons[i].velocity.y {
                allMatch = false
                
                break
            }
        }
        
        if allMatch {
            break
        }
    }
    
    planet.reset()
    
    while true {
        planet.step()
        
        steps.2 += 1
        
        var allMatch = true
        
        for i in 0...(originalMoons.count - 1) {
            if planet.moons[i].position.z != originalMoons[i].position.z && planet.moons[i].velocity.z != originalMoons[i].velocity.z {
                allMatch = false
                
                break
            }
        }
        
        if allMatch {
            break
        }
    }
    
    return ([steps.0, steps.1, steps.2].reduce(into: 1) { $0 = LCM($0, $1) } * 2)
}
