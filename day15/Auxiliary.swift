import Foundation

public var computerAtHolePosition: Computer!
public var coordinateOfHolePosition: Coordinate!

public func calculateSmallest(computer: Computer, count: Int = 0, visited: [Coordinate] = []) -> Int {
    var smallest = Int.max
    
    var visited = visited
    
    if visited.count == 0 {
        visited = [Coordinate(x: 0, y: 0)]
    }
    
    let currentCoordinate = visited[visited.count - 1]
    
    for i in (1...4) {
        let nextCoordinate: Coordinate
        
        switch i {
        case 1:
            nextCoordinate = currentCoordinate + Coordinate(x: 0, y: 1)
        case 2:
            nextCoordinate = currentCoordinate + Coordinate(x: 0, y: -1)
        case 3:
            nextCoordinate = currentCoordinate + Coordinate(x: -1, y: 0)
        case 4:
            nextCoordinate = currentCoordinate + Coordinate(x: 1, y: 0)
        default:
            fatalError("This can never happen...")
        }
        
        if visited.contains(nextCoordinate) {
            continue
        }
        
        let localComputer = computer.copy()
        localComputer.nextInput = i
        localComputer.run()
        
        let localCount = count + 1
        
        switch localComputer.outputs.last! {
        case 0:
            continue
        case 1:
            let s = calculateSmallest(computer: localComputer, count: localCount, visited: visited + [nextCoordinate])
            
            if s < smallest {
                smallest = s
            }
        case 2:
            computerAtHolePosition = localComputer.copy()
            coordinateOfHolePosition = nextCoordinate
            
            if localCount < smallest {
                smallest = localCount
            }
        default:
            fatalError("Unknown output!")
        }
    }
    
    return smallest
}

private func auxiliaryForPart2(computerTuple: (Computer, Coordinate), count: Int = 0, visited: [Coordinate] = []) -> (computers: [(Computer, Coordinate)], count: Int, visited: [Coordinate]) {
    var biggest = count
    
    var visited = visited
    
    let computer = computerTuple.0
    let currentCoordinate = computerTuple.1
    
    var activeComputers: [(Computer, Coordinate)] = []
    
    for i in (1...4) {
        let nextCoordinate: Coordinate
        
        switch i {
        case 1:
            nextCoordinate = currentCoordinate + Coordinate(x: 0, y: 1)
        case 2:
            nextCoordinate = currentCoordinate + Coordinate(x: 0, y: -1)
        case 3:
            nextCoordinate = currentCoordinate + Coordinate(x: -1, y: 0)
        case 4:
            nextCoordinate = currentCoordinate + Coordinate(x: 1, y: 0)
        default:
            fatalError("This can never happen...")
        }
        
        guard !visited.contains(nextCoordinate) else {
            continue
        }
        
        visited.append(nextCoordinate)
        
        let localComputer = computer.copy()
        localComputer.nextInput = i
        localComputer.run()
        
        switch localComputer.outputs.last! {
        case 0, 2:
            //  Do nothing.
            
            continue
        case 1:
            activeComputers.append((localComputer, nextCoordinate))
            
            biggest = count + 1
            
        default:
            fatalError("Unknown output!")
        }
    }
    
    return (activeComputers, biggest, visited)
}

public func solvePart2() -> Int {
    var activeComputers = [(computerAtHolePosition!, coordinateOfHolePosition!)]
    var count = 0
    var visited = [coordinateOfHolePosition!]
    
    while activeComputers.count != 0 {
        var localActiveComputers: [(Computer, Coordinate)] = []
        
        for c in activeComputers {
            let result = auxiliaryForPart2(computerTuple: c, count: count, visited: visited)
            
            localActiveComputers += result.computers
            visited = result.visited
        }
        
        activeComputers = localActiveComputers
        count += 1
    }
    
    return count
}
