import Foundation

//  Adapted from https://gist.github.com/proxpero/9fd3c4726d19242365d6

//: Permutations
//  based on https://www.objc.io/blog/2014/12/08/functional-snippet-10-permutations/
//  but updated for Swift 2.0 (Xcode 7.0)
extension Array {
    func decompose() -> (Iterator.Element, [Iterator.Element])? {
        guard let x = first else { return nil }
        return (x, Array(self[1..<count]))
    }
}

func between<T>(_ x: T, _ ys: [T]) -> [[T]] {
    guard let (head, tail) = ys.decompose() else { return [[x]] }
    return [[x] + ys] + between(x, tail).map { [head] + $0 }
}

let example = between(0, [1, 2, 3])

public func permutations<T>(_ xs: [T]) -> [[T]] {
    guard let (head, tail) = xs.decompose() else { return [[]] }
    return permutations(tail).flatMap { between(head, $0) }
}
