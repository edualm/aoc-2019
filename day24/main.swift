import Foundation

assert(test(), "Test failed!")

let challengeInput = [
    [".", "#", "#", "#", "."].map { Tile(rawValue: $0)! },
    [".", ".", "#", ".", "#"].map { Tile(rawValue: $0)! },
    [".", ".", ".", "#", "#"].map { Tile(rawValue: $0)! },
    ["#", ".", "#", "#", "#"].map { Tile(rawValue: $0)! },
    [".", ".", "#", ".", "."].map { Tile(rawValue: $0)! }
]

print("Part 1 result: \(part1(board: challengeInput))")
