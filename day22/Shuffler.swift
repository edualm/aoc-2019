import Foundation

public protocol Shuffler {
    func shuffle(_ deck: [Int]) -> [Int]
}

public struct NewStack: Shuffler {
    public init() { }
    
    public func shuffle(_ deck: [Int]) -> [Int] {
        return deck.reversed()
    }
}

public struct Cut: Shuffler {
    let n: Int
    
    public init(_ n: Int) {
        self.n = n
    }
    
    public func shuffle(_ deck: [Int]) -> [Int] {
        return n >= 0 ? shufflePositive(deck) : shuffleNegative(deck)
    }
    
    private func shufflePositive(_ deck: [Int]) -> [Int]{
        var newDeck = deck
        var newDeckLastPart: [Int] = []
        
        for _ in 0 ... (n - 1) {
            newDeckLastPart.append(newDeck.removeFirst())
        }
        
        return newDeck + newDeckLastPart
    }
    
    private func shuffleNegative(_ deck: [Int]) -> [Int] {
        var newDeck = deck
        var newDeckFirstPart: [Int] = []
        
        for _ in 0 ... ((n * -1) - 1) {
            newDeckFirstPart.append(newDeck.removeLast())
        }
        
        newDeckFirstPart.reverse()
        
        return newDeckFirstPart + newDeck
    }
}

public struct DealWithIncrement: Shuffler {
    let n: Int
    
    public init(_ n: Int) {
        precondition(n > 0)
        
        self.n = n
    }
    
    public func shuffle(_ deck: [Int]) -> [Int] {
        let DECK_MAX = (deck.count - 1)
        
        var newDeck: [Int?] = (0...DECK_MAX).map { _ in nil }
        
        var newDeckPointer = 0
        
        deck.forEach { card in
            newDeck[newDeckPointer] = card
            
            newDeckPointer += n
            
            if newDeckPointer > DECK_MAX {
                newDeckPointer -= (DECK_MAX + 1)
            }
        }
        
        return newDeck as! [Int]
    }
}
