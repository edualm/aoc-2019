import Foundation

func test1() -> Bool {
    return shuffle((0...9).map { $0 }, with: [DealWithIncrement(3)]) == [0, 7, 4, 1, 8, 5, 2, 9, 6, 3]
}

func test2() -> Bool {
    let input: [Shuffler] = [
        Cut(6),
        DealWithIncrement(7),
        NewStack()
    ]
    
    let deck = (0...9).map { $0 }
    
    return shuffle(deck, with: input) == [3, 0, 7, 4, 1, 8, 5, 2, 9, 6]
}

func test3() -> Bool {
    let input: [Shuffler] = [
        DealWithIncrement(7),
        DealWithIncrement(9),
        Cut(-2)
    ]
    
    let deck = (0...9).map { $0 }
    
    return shuffle(deck, with: input) == [6, 3, 0, 7, 4, 1, 8, 5, 2, 9]
}

func test4() -> Bool {
    let input: [Shuffler] = [
        DealWithIncrement(7),
        DealWithIncrement(9),
        Cut(-2)
    ]
    
    let deck = (0...9).map { $0 }
    
    return shuffle(deck, with: input) == [6, 3, 0, 7, 4, 1, 8, 5, 2, 9]
}

func test5() -> Bool {
    let input: [Shuffler] = [
        NewStack(),
        Cut(-2),
        DealWithIncrement(7),
        Cut(8),
        Cut(-4),
        DealWithIncrement(7),
        Cut(3),
        DealWithIncrement(9),
        DealWithIncrement(3),
        Cut(-1)
    ]
    
    let deck = (0...9).map { $0 }
    
    return shuffle(deck, with: input) == [9, 2, 5, 8, 1, 4, 7, 0, 3, 6]
}

public func test() -> Bool {
    return test1() && test2() && test3() && test4() && test5()
}
