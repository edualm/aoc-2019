import Foundation

let testInput = """
<x=-1, y=0, z=2>
<x=2, y=-10, z=-7>
<x=4, y=-8, z=8>
<x=3, y=5, z=-1>
"""

func parse(input: String) -> [Moon] {
    return input.split(separator: "\n").map {
        let spl = $0.split(separator: " ")
        
        let x = Int(String(spl[0].dropFirst(3).dropLast()))!
        let y = Int(String(spl[1].dropFirst(2).dropLast()))!
        let z = Int(String(spl[2].dropFirst(2).dropLast()))!
        
        return Moon(position: XYZ(x, y, z))
    }
}

func testPart1() {
    var planet = Planet(moons: parse(input: testInput))
    
    for _ in 0...9 {
        planet.step()
    }
    
    let energy = planet.moons.reduce(into: 0) { $0 += $1.energy }
    
    guard energy == 179 else {
        fatalError("Part 1 test failed!")
    }
}

func testPart2() {
    var planet = Planet(moons: parse(input: testInput))
    
    let solution = findPart2Solution(planet: &planet)
    
    guard solution == 2772 else {
        fatalError("Part 2 test failed! Expected 2772, got \(solution) instead...")
    }
}

testPart1()
testPart2()

//  Part 1

let challengeInput = """
<x=4, y=12, z=13>
<x=-9, y=14, z=-3>
<x=-7, y=-1, z=2>
<x=-11, y=17, z=-1>
"""

var planet = Planet(moons: parse(input: challengeInput))

for _ in 0...999 {
    planet.step()
}

print("Part 1 answer: \(planet.moons.reduce(into: 0) { $0 += $1.energy })")

//  Part 2

planet = Planet(moons: parse(input: challengeInput))

print("Part 2 answer: \(findPart2Solution(planet: &planet))")
