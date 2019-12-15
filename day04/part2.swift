import UIKit

struct Rule {
    let min: Int
    let max: Int
    
    func validate(_ number: Int) -> Bool {
        guard number >= min && number <= max else { return false }
        
        var numberAsString = String(number)
        
        while numberAsString.count < 6 {
            numberAsString = "0" + numberAsString
        }
        
        var previous = 0
        
        for digitAsString in numberAsString {
            let digit = Int(String(digitAsString))!
            
            if digit < previous {
                return false
            }
            
            previous = digit
        }
        
        var previousChar: Character?
        var previousCharSeenCount: Int = 0
        
        for digitAsString in numberAsString {
            guard let pc = previousChar else {
                previousChar = digitAsString
                previousCharSeenCount = 1
                
                continue
            }
            
            if digitAsString == pc {
                previousCharSeenCount += 1
                
                continue
            }
            
            if previousCharSeenCount == 2 {
                return true
            }
            
            previousChar = digitAsString
            previousCharSeenCount = 1
        }
        
        if previousCharSeenCount == 2 {
            return true
        }
        
        return false
    }
}

//  Tests

let testRule = Rule(min: 0, max: 999999)

if !testRule.validate(112233) {
    fatalError()
}

if testRule.validate(123444) {
    fatalError()
}

if !testRule.validate(111122) {
    fatalError()
}

//  Challenge!

let rule = Rule(min: 240298, max: 784956)

var counter = 0

for i in 240298...1000000 {
    if rule.validate(i) {
        counter += 1
    }
}

counter
