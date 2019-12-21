import Foundation

private extension String {
    var ascii: [Int] {
        return Array(self).map { $0.ascii }
    }
}

private extension Character {
    var ascii: Int {
        return Int(unicodeScalars.first!.value)
    }
}

public extension Computer {
    @discardableResult public func run(withString input: String, newLine: Bool = true) -> ComputationState {
        var result: ComputationState!
        
        precondition(input.ascii.count >= 0)
        
        input.ascii.forEach {
            nextInput = $0
            
            result = run()
        }
        
        if newLine {
            nextInput = 10
            
            result = run()
        }
        
        return result
    }
}
