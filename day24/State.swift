import Foundation

public enum Tile: Character {
    public typealias RawValue = Character
    
    case bug = "#"
    case empty = "."
}

public typealias Board = [[Tile]]

public struct State: Equatable {
    public let representation: Board
    
    public init(representation: Board) {
        self.representation = representation
    }
    
    private func safeGet(at coordinate: Coordinate2D) -> Tile {
        if coordinate.x >= 0 &&
            coordinate.y >= 0 &&
            coordinate.y < representation.count &&
            coordinate.x < representation[coordinate.y].count {
            
            return representation[coordinate.y][coordinate.x]
        }
        
        return .empty
    }
    
    private func adjacentBugCount(at coordinate: Coordinate2D) -> Int {
        return [
            Coordinate2D(coordinate.x - 1, coordinate.y),
            Coordinate2D(coordinate.x + 1, coordinate.y),
            Coordinate2D(coordinate.x, coordinate.y - 1),
            Coordinate2D(coordinate.x, coordinate.y + 1)
            ].reduce(into: 0) { (accumulator, currentValue) in
                accumulator += safeGet(at: currentValue) == .bug ? 1 : 0
        }
    }
    
    private func nextState(for coordinate: Coordinate2D) -> Tile {
        let currentTile = safeGet(at: coordinate)
        let adjacentCount = adjacentBugCount(at: coordinate)
        
        if currentTile == .bug && adjacentCount != 1 {
            return .empty
        }
        
        if currentTile == .empty && (adjacentCount == 1 || adjacentCount == 2) {
            return .bug
        }
        
        return currentTile
    }
    
    public func next() -> State {
        var next = representation
        
        for y in 0...(representation.count - 1) {
            for x in 0...(representation[y].count - 1) {
                next[y][x] = nextState(for: Coordinate2D(x, y))
            }
        }
        
        return State(representation: next)
    }
    
    public var biodiversityRating: Int {
        var rating: Int = 0
        
        for y in 0...(representation.count - 1) {
            for x in 0...(representation[y].count - 1) {
                if safeGet(at: Coordinate2D(x, y)) == .bug {
                    rating += (pow(2, (y * 5) + x) as NSDecimalNumber).intValue
                }
            }
        }
        
        return rating
    }
}
