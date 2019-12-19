import Foundation

public typealias Board = [[Character]]

private struct Coordinate2D: Hashable {
    let x: Int
    let y: Int
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    init(_ x: Int, _ y: Int) {
        self.init(x: x, y: y)
    }
    
    var hashValue: Int {
        return x.hashValue ^ y.hashValue
    }
    
    static func == (lhs: Coordinate2D, rhs: Coordinate2D) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

public struct BoardWalker {
    private enum Direction {
        case up
        case down
        case left
        case right
        
        static var all: [Direction] {
            return [.up, .down, .left, .right]
        }
    }
    
    private struct BoardRepresentation {
        let state: Board
        let coordinate: Coordinate2D
        let keys: [Character]
    }
    
    private var currentStates: [(BoardRepresentation, Int)]
    private var pastStates: [Coordinate2D: Set<Set<Character>>]
    
    public init(initialState: Board) {
        self.currentStates = [(BoardRepresentation(state: initialState,
                                                   coordinate: BoardWalker.getPosition(board: initialState)!,
                                                   keys: []),
                               0)]
        self.pastStates = [:]
    }
    
    private func checkForCompletion(board: Board) -> Bool {
        for y in (0...(board.count - 1)) {
            for x in (0...(board[y].count - 1)) {
                let currentPiece = board[y][x]
                
                if currentPiece != "." && currentPiece != "#" && currentPiece != "@" {
                    if String(currentPiece).uppercased() != String(currentPiece) {
                        return false
                    }
                }
            }
        }
        
        return true
    }
    
    private static func getPosition(board: Board, piece: Character = "@") -> Coordinate2D? {
        for y in (0...(board.count - 1)) {
            for x in (0...(board[y].count - 1)) {
                if board[y][x] == piece {
                    return Coordinate2D(x: x, y: y)
                }
            }
        }
        
        return nil
    }
    
    private static func getPosition(boardRepresentation: BoardRepresentation, piece: Character = "@") -> Coordinate2D? {
        if piece == "@" {
            return boardRepresentation.coordinate
        }
        
        return getPosition(board: boardRepresentation.state, piece: piece)
    }
    
    private func move(_ direction: Direction, on boardRepresentation: BoardRepresentation) -> (boardRepresentation: BoardRepresentation?, shouldCheckForCompletion: Bool) {
        var board = boardRepresentation.state
        let currentPosition = boardRepresentation.coordinate
        
        let nextPosition: Coordinate2D
        
        switch direction {
        case .up:
            nextPosition = Coordinate2D(currentPosition.x, currentPosition.y - 1)
        case .down:
            nextPosition = Coordinate2D(currentPosition.x, currentPosition.y + 1)
        case .left:
            nextPosition = Coordinate2D(currentPosition.x - 1,currentPosition.y)
        case .right:
            nextPosition = Coordinate2D(currentPosition.x + 1,currentPosition.y)
        }
        
        guard nextPosition.x >= 0 && nextPosition.y >= 0 && nextPosition.x < board[0].count && nextPosition.y < board.count else {
            return (nil, false)
        }
        
        var newBoard = board
        
        let currentPiece = board[nextPosition.y][nextPosition.x]
        
        switch currentPiece {
        case "#":
            //  Hit a wall, can't move!
            
            return (nil, false)
        case ".":
            //  Blank space
            
            newBoard[nextPosition.y][nextPosition.x] = "@"
            newBoard[currentPosition.y][currentPosition.x] = "."
            
            return (BoardRepresentation(state: newBoard, coordinate: nextPosition, keys: boardRepresentation.keys), false)
        default:
            let uppercasedLetter = Character(String(currentPiece).uppercased())
            
            if uppercasedLetter == currentPiece {
                //  Found a locked door!
                
                //  Check if a key exists...
                
                if BoardWalker.getPosition(boardRepresentation: boardRepresentation, piece: Character(String(uppercasedLetter).lowercased())) != nil {
                    return (nil, false)
                } else {
                    //  Treat as blank space...
                    
                    newBoard[nextPosition.y][nextPosition.x] = "@"
                    newBoard[currentPosition.y][currentPosition.x] = "."
                    
                    return (BoardRepresentation(state: newBoard, coordinate: nextPosition, keys: boardRepresentation.keys), false)
                }
            } else {
                //  Found a key!
                
                newBoard[nextPosition.y][nextPosition.x] = "@"
                newBoard[currentPosition.y][currentPosition.x] = "."
                
                if let doorPosition = BoardWalker.getPosition(boardRepresentation: boardRepresentation, piece: uppercasedLetter) {
                    newBoard[doorPosition.y][doorPosition.x] = "."
                }
                
                return (BoardRepresentation(state: newBoard,
                                            coordinate: nextPosition,
                                            keys: boardRepresentation.keys + [currentPiece]),
                        true)
            }
        }
    }
    
    public mutating func step() -> Int? {
        let currentStatesCopy = currentStates
        currentStates = []
        
        for state in currentStatesCopy {
            for direction in Direction.all {
                let newState = move(direction, on: state.0)
                
                guard let br = newState.boardRepresentation else {
                    continue
                }
                
                let pastKeysAtThisCoordinate = pastStates[br.coordinate]
                
                if pastKeysAtThisCoordinate != nil && pastKeysAtThisCoordinate!.contains(Set<Character>(br.keys)) {
                    continue
                }
                
                if pastKeysAtThisCoordinate == nil {
                    pastStates[br.coordinate] = Set<Set<Character>>()
                }
                
                pastStates[br.coordinate]!.insert(Set<Character>(br.keys))
                
                currentStates.append((br, state.1 + 1))
                
                if newState.shouldCheckForCompletion && checkForCompletion(board: br.state) {
                    return state.1 + 1
                }
            }
        }
        
        return nil
    }
}
