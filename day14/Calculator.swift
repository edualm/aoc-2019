import Foundation

public struct ChemicalWithQuantity: Hashable {
    public let chemical: String
    public let quantity: Int
    
    public init(chemical: String, quantity: Int) {
        self.chemical = chemical
        self.quantity = quantity
    }
}

public struct Rule: Hashable {
    public let input: [ChemicalWithQuantity]
    public let output: ChemicalWithQuantity
    
    public init(input: [ChemicalWithQuantity], output: ChemicalWithQuantity) {
        self.input = input
        self.output = output
    }
}

public struct Calculator {
    enum CalculationError: Error {
        case insufficientMaterials
        case noMatchingRule
    }
    
    var rules: [Rule]
    
    public private(set) var availableMaterials: [String: Int] = ["ORE": 1_000_000_000_000]
    
    public init(rules: [Rule]) {
        self.rules = rules
    }
    
    mutating func getAvailable(material: String) -> Int {
        if let available = availableMaterials[material] {
            return available
        }
        
        availableMaterials[material] = 0
        
        return 0
    }
    
    public mutating func generate(chemical: String, quantity: Int = 1) throws {
        guard let rule = rules.first(where: { $0.output.chemical == chemical }) else {
            throw CalculationError.noMatchingRule
        }
        
        var numberOfReactions = quantity / rule.output.quantity
        
        if quantity % rule.output.quantity != 0 {
            numberOfReactions += 1
        }
        
        for requiredInputChemical in rule.input {
            let requiredQuantity = requiredInputChemical.quantity * numberOfReactions
            
            while getAvailable(material: requiredInputChemical.chemical) < requiredQuantity {
                try generate(chemical: requiredInputChemical.chemical, quantity: (requiredQuantity - getAvailable(material: requiredInputChemical.chemical)))
            }
            
            availableMaterials[requiredInputChemical.chemical] = availableMaterials[requiredInputChemical.chemical]! - requiredQuantity
            
            if availableMaterials[requiredInputChemical.chemical]! < 0 {
                throw CalculationError.insufficientMaterials
            }
        }
        
        let currentAvailable = getAvailable(material: chemical)
        
        availableMaterials[chemical] = currentAvailable + (rule.output.quantity * numberOfReactions)
    }
}
