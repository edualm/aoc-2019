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
        
        for digitAsString in numberAsString {
            guard let pc = previousChar else {
                previousChar = digitAsString
                
                continue
            }
            
            if digitAsString == pc {
                return true
            }
            
            previousChar = digitAsString
        }
        
        return false
    }
}

//  Tests

let testRule = Rule(min: 0, max: 999999)

if !testRule.validate(111111) {
    fatalError()
}

if testRule.validate(223450) {
    fatalError()
}

if testRule.validate(123789) {
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
