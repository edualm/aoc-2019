import Foundation

precondition(test())

print("All tests passed!")

//  Challenge

let deck = (0...10006).map { $0 }
precondition(deck.count == 10007)

let input = parse(Input)
precondition(input.count == Input.split(separator: "\n").count)

print("Part 1 solution: \(shuffle(deck, with: input).firstIndex(of: 2019)!)")
