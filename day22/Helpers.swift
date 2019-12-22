import Foundation

public func shuffle(_ deck: [Int], with shufflers: [Shuffler]) -> [Int] {
    var newDeck = deck
    
    shufflers.forEach { newDeck = $0.shuffle(newDeck) }
    
    return newDeck
}

public func shuffle(_ deck: [Int], with shufflers: [Shuffler], count: Int) -> [Int] {
    var newDeck = deck
    
    for _ in (0...(count - 1)) {
        newDeck = shuffle(newDeck, with: shufflers)
    }
    
    return newDeck
}
