import Foundation

public func parse(_ input: String) -> [Shuffler] {
    return input.split(separator: "\n").map {
        if $0 == "deal into new stack" {
            return NewStack()
        } else if $0.contains("deal with increment") {
            return DealWithIncrement(Int($0.dropFirst("deal with increment ".count))!)
        } else if $0.contains("cut") {
            return Cut(Int($0.dropFirst("cut ".count))!)
        }
        
        fatalError("Not implemented: \($0)")
    }
}
