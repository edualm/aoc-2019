import Foundation

public func parse(input: String) -> Board {
    let inputSplitByLine = input.split(separator: "\n")
    
    var board: Board = []
    
    for y in (0...(inputSplitByLine.count - 1)) {
        var line: [Character] = []
        
        for x in (0...(inputSplitByLine[y].count - 1)) {
            let idx = inputSplitByLine[y].index(inputSplitByLine[y].startIndex, offsetBy: x)
            
            line.append(inputSplitByLine[y][idx])
        }
        
        board.append(line)
    }
    
    return board
}
