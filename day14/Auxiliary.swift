import Foundation

public func parseRules(from input: String) -> [Rule] {
    return input.split(separator: "\n").map {
        let parts = $0.split(separator: "=")
        
        let firstPartComponents = parts[0].components(separatedBy: ",")
        
        var inputs: [ChemicalWithQuantity] = []
        
        for input in firstPartComponents {
            let separated = input.split(separator: " ")
            
            let quantity = Int(separated[0])!
            let chemical = String(separated[1])
            
            inputs.append(ChemicalWithQuantity(chemical: chemical,
                                               quantity: quantity))
        }
        
        let output = parts[1].dropFirst(2).split(separator: " ")
        
        return Rule(input: inputs,
                    output: ChemicalWithQuantity(chemical: String(output[1]),
                                                 quantity: Int(output[0])!))
    }
}

public func solveSecond(inputChallenge: String) -> Int {
    var currentMin = 0
    var currentMax = 1_000_000_000_000
    
    var best = 0
    
    while currentMin != currentMax {
        let current = (currentMin + currentMax) / 2
        
        var calculator = Calculator(rules: parseRules(from: inputChallenge))
        
        do {
            try calculator.generate(chemical: "FUEL", quantity: current)
            
            best = current
            currentMin = current + 1
        } catch {
            currentMax = current
        }
    }
    
    return best
}
