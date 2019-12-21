import Foundation

public func parse(input: String) -> Maze {
    let inputSplitByLine = input.split(separator: "\n")
    
    var maze: Maze = [:]
    
    for y in (0...(inputSplitByLine.count - 1)) {
        for x in (0...(inputSplitByLine[y].count - 1)) {
            let idx = inputSplitByLine[y].index(inputSplitByLine[y].startIndex, offsetBy: x)
            
            if inputSplitByLine[y][idx] != " " {
                maze[Coordinate(x: x, y: y)] = inputSplitByLine[y][idx]
            }
        }
    }
    
    return maze
}

public func calculatePart1(input: String) -> Int {
    let mw = MazeWalker(maze: parse(input: input))
    
    var queue = [(mw.startPosition!, [] as [Coordinate], 0, false)]
    
    while true {
        let locQueue = queue.sorted { first, second in
            first.2 < second.2
        }
        
        if locQueue.count == 0 {
            print("Didn't find an answer!")
            
            break
        }
        
        queue = []
        
        locQueue.forEach {
            mw.walk(from: $0.0, visited: $0.1, steps: $0.2).forEach {
                queue.append($0)
            }
        }
        
        var ret: Int? = nil
        
        queue.forEach {
            if $0.3 {
                ret = $0.2
            }
        }
        
        if let r = ret {
            return r
        }
    }
    
    return -1
}
