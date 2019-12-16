import Foundation

public class FFT {
    enum ProcessingError: Error {
        case unacceptableOffset
    }
    
    let basePattern: [Int]
    
    var currentPattern: [Int] = []
    var currentPatternPosition: Int = 0
    
    public init(pattern: [Int]) {
        self.basePattern = pattern
    }
    
    public func setupPattern(withRepetitions repetitions: Int) {
        currentPattern = []
        currentPatternPosition = 0
        
        for val in basePattern {
            for _ in 0...(repetitions - 1) {
                currentPattern.append(val)
            }
        }
    }
    
    func next() -> Int {
        currentPatternPosition += 1
        
        if currentPattern.count <= currentPatternPosition {
            currentPatternPosition = 0
        }
        
        return currentPattern[currentPatternPosition]
    }
    
    public func operate(on signal: [Int]) -> [Int] {
        var output: [Int] = []
        
        for n in 1...(signal.count) {
            setupPattern(withRepetitions: n)
            
            var sum = 0
            
            for char in signal {
                sum -= char * next()
            }
            
            sum = sum % 10
            
            if sum < 0 {
                sum *= -1
            }
            
            output.append(sum)
        }
        
        return output
    }
    
    public func operateWithOffset(on signal: [Int]) -> [Int] {
        var output: [Int] = signal
        
        var sum = 0
        
        var i = output.count - 1
        
        while i >= 0 {
            sum += output[i]
            output[i] = sum % 10
            
            i -= 1
        }
        
        return output
    }
}
