import Foundation

public struct Robot {
    
    enum Position {
        case up
        case down
        case right
        case left
        
        func rotating(_ position: Position) -> Position {
            guard position == .right || position == .left else {
                fatalError("position must be either right or left")
            }
            
            switch self {
            case .up:
                return position == .right ? .right : .left
            case .down:
                return position == .right ? .left : .right
            case .right:
                return position == .right ? .down : .up
            case .left:
                return position == .right ? .up : .down
            }
        }
    }
    
    public enum Color: Int {
        case black = 0
        case white = 1
    }
    
    var facingPosition = Position.up
    var currentPosition = Coordinate(x: 0, y: 0)
    
    public private(set) var board: [Coordinate: Color] = [
        Coordinate(x: 0, y: 0): .black
    ]
    
    public private(set) var paintedCoordinates: [Coordinate] = []
    
    var brain: Computer
    
    public init(brain: Computer, startingColor: Color = .black) {
        self.brain = brain
        self.board[Coordinate(x: 0, y: 0)] = startingColor
    }
    
    mutating public func step() -> Computer.ComputationState {
        let currentColor = board[currentPosition] ?? .black
        
        brain.nextInput = currentColor.rawValue
        
        let result = brain.run()
        
        board[currentPosition] = brain.outputs[brain.outputs.count - 2] == 0 ? .black : .white
        
        if !paintedCoordinates.contains(currentPosition) {
            paintedCoordinates.append(currentPosition)
        }
        
        facingPosition = facingPosition.rotating(brain.outputs[brain.outputs.count - 1] == 0 ? .left : .right)
        
        switch facingPosition {
        case .up:
            currentPosition = Coordinate(x: currentPosition.x, y: currentPosition.y - 1)
        case .down:
            currentPosition = Coordinate(x: currentPosition.x, y: currentPosition.y + 1)
        case .right:
            currentPosition = Coordinate(x: currentPosition.x + 1, y: currentPosition.y)
        case .left:
            currentPosition = Coordinate(x: currentPosition.x - 1, y: currentPosition.y)
        }
        
        return result
    }
    
}
