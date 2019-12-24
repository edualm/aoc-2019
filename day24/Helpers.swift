import Foundation

func step(_ pastStates: [State]) -> (newStates: [State], result: State?) {
    let nextState = pastStates.last!.next()
    
    if pastStates.contains(nextState) {
        return (pastStates, nextState)
    }
    
    return (pastStates + [nextState], nil)
}

public func test() -> Bool {
    let initialTestState = [
        [".", ".", ".", ".", "#"].map { Tile(rawValue: $0)! },
        ["#", ".", ".", "#", "."].map { Tile(rawValue: $0)! },
        ["#", ".", ".", "#", "#"].map { Tile(rawValue: $0)! },
        [".", ".", "#", ".", "."].map { Tile(rawValue: $0)! },
        ["#", ".", ".", ".", "."].map { Tile(rawValue: $0)! }
    ]
    
    let expectedResult = 2129920
    
    return part1(board: initialTestState) == expectedResult
}

public func part1(board: Board) -> Int {
    var pastStates = [State(representation: board)]
    
    while true {
        let (newStates, result) = step(pastStates)
        
        pastStates = newStates
        
        if let r = result {
            return r.biodiversityRating
        }
    }
}
