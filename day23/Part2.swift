import Foundation

public struct Part2: Runnable {
    var computers: [Computer] = []
    
    var natPacket: (x: Int, y: Int)? = nil
    
    var lastSentNatY: Int? = nil
    
    var stepsWithoutSentPacket: Int = 0
    
    public init() { }
    
    mutating public func run() {
        computers = []
        
        for i in (0 ... 49) {
            let c = Computer(program: Input, waitForInput: false)
            
            c.addInput(i)
            
            c.runSingle()
            
            computers.append(c)
        }
        
        while step() { }
    }
    
    mutating func step() -> Bool {
        computers.forEach {
            if $0.outputs.count >= 3 {
                if $0.outputs[0] == 255 {
                    natPacket = ($0.outputs[1], $0.outputs[2])
                } else {
                    computers[$0.outputs[0]].addInput($0.outputs[1])
                    computers[$0.outputs[0]].addInput($0.outputs[2])
                }
                
                $0.clearOutputs()
                
                stepsWithoutSentPacket = 0
            } else {
                stepsWithoutSentPacket += 1
            }
            
            $0.runSingle()
        }
        
        if stepsWithoutSentPacket >= 100_000 {
            computers[0].addInput(natPacket!.x)
            computers[0].addInput(natPacket!.y)
            
            if lastSentNatY != nil && lastSentNatY! == natPacket!.y {
                print("Part 2 result: \(lastSentNatY!)")
                
                return false
            }
            
            lastSentNatY = natPacket!.y
            natPacket = nil
            stepsWithoutSentPacket = 0
        }
        
        return true
    }
}
