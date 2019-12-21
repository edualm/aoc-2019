import Foundation

public typealias Maze = [Coordinate: Character]

let alphabet = "abcdefghijklmnopqrstuvwxyz".uppercased()

public struct MazeWalker {
    let maze: Maze
    
    public init(maze: Maze) {
        self.maze = maze
    }
    
    func positionSameChar(character: Character) -> Coordinate? {
        let startPositions = Array(maze.filter { (crd, char) in
            return char == character
        }.keys)
        
        if startPositions[0].y == startPositions[1].y {
            //  same line
            
            let sorted = startPositions.sorted { (crd1, crd2) in crd1.x < crd2.x }
            
            if sorted[0].x == 0 {
                return Coordinate(x: sorted[1].x + 1, y: sorted[1].y)
            } else {
                return Coordinate(x: sorted[0].x - 1, y: sorted[1].y)
            }
        }
        
        if startPositions[0].x == startPositions[1].x {
            //  same column
            
            let sorted = startPositions.sorted { (crd1, crd2) in crd1.y < crd2.y }
            
            if sorted[0].y == 0 {
                return Coordinate(x: sorted[0].x, y: sorted[1].y + 1)
            } else {
                return Coordinate(x: sorted[0].x, y: sorted[0].y - 1)
            }
        }
        
        return nil
    }
    
    public var startPosition: Coordinate? {
        return positionSameChar(character: "&")
    }
    
    public var endPosition: Coordinate? {
        return positionSameChar(character: "*")
    }
    
    func points(around coordinate: Coordinate) -> [Coordinate] {
        return [Coordinate(x: coordinate.x - 1, y: coordinate.y),
                Coordinate(x: coordinate.x + 1, y: coordinate.y),
                Coordinate(x: coordinate.x, y: coordinate.y - 1),
                Coordinate(x: coordinate.x, y: coordinate.y + 1)].compactMap { crd in
                    
                    if let point = maze[crd], point != "#" {
                        return crd
                    }
                    
                    return nil
        }
    }
    
    func passThroughPortal(at start: Coordinate) -> (next: Coordinate, block: Coordinate)? {
        let otherPart = points(around: start).compactMap { crd -> Coordinate? in
            guard let char = maze[crd], alphabet.contains(char) else { return nil }
            
            return crd
        }.first!
        
        let otherPortalStart = maze.first { (key, value) in
            value == maze[otherPart] && key != otherPart && points(around: key).contains { maze[$0] == maze[start] }
        }?.key
        
        guard otherPortalStart != nil else { return nil }
        
        var block = otherPortalStart
        
        var ret = points(around: otherPortalStart!).compactMap { crd -> Coordinate? in
            guard maze[crd] != nil && maze[crd] == "." else { return nil }
            
            return crd
        }.first
        
        if ret == nil {
            let mid = points(around: otherPortalStart!).compactMap { crd -> Coordinate? in
                guard maze[crd] != nil && maze[crd] != "." else { return nil }
                
                return crd
            }.first!
            
            block = mid
            
            ret = points(around: mid).compactMap { crd -> Coordinate? in
                guard maze[crd] != nil && maze[crd] == "." else { return nil }
                
                return crd
            }.first
        }
        
        //  print("Entered at \(start), left at \(ret!), blocked \(block!).")
        
        return (ret!, block!)
    }
    
    public func walk(from start: Coordinate, visited: [Coordinate] = [], steps: Int = 0) -> [(next: Coordinate, visited: [Coordinate], steps: Int, finished: Bool)] {
        let toVisit = points(around: start).filter { crd in maze[crd] != "&" && !visited.contains(crd) }
        
        let found = toVisit.compactMap { maze[$0] == "*" ? $0 : nil }.first
        
        if found != nil {
            return [(found!, visited, steps, true)]
        }
        
        return toVisit.map { crd -> (next: Coordinate, visited: [Coordinate], steps: Int, finished: Bool) in
            if maze[crd] == "." {
                return (crd, visited + [start], steps + 1, false)
            }
            
            let afterPortal = passThroughPortal(at: crd)!
            
            return (afterPortal.next, visited + [start, afterPortal.block], steps + 1, false)
        }
    }
}
