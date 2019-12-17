import Foundation

public func calculateMapAndCalibrationScore(input: [String]) -> ([[String]], Int) {
    var outputAs2DArray: [[String]] = []
    
    var currentOutputArray: [String] = []
    
    for o in input {
        switch o {
        case "\n":
            outputAs2DArray.append(currentOutputArray)
            currentOutputArray = []
        default:
            currentOutputArray.append(o)
        }
    }
    
    outputAs2DArray.removeLast()
    
    var c1answer = 0
    
    for y in 0...(outputAs2DArray.count - 1) {
        for x in 0...(outputAs2DArray[y].count - 1) {
            guard
                y > 0 &&
                    x > 0 &&
                    y < (outputAs2DArray.count - 1) &&
                    x < (outputAs2DArray[y].count - 1) else {
                        continue
            }
            
            if
                outputAs2DArray[y][x] == "#" &&
                    outputAs2DArray[y - 1][x] != "." &&
                    outputAs2DArray[y + 1][x] != "." &&
                    outputAs2DArray[y][x - 1] != "." &&
                    outputAs2DArray[y][x + 1] != "." {
                
                outputAs2DArray[y][x] = "O"
                
                c1answer += y * x
            }
        }
    }
    
    return (outputAs2DArray, c1answer)
}
