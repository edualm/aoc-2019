import Foundation

public func GCD(_ a: Int, _ b: Int) -> Int {
    guard a % b != 0 else {
        return b
    }
    
    return GCD(b, a % b)
}

public func LCM(_ a: Int, _ b: Int) -> Int {
    return a * b / GCD(a, b);
}
