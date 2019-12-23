import Foundation

public struct Part1: Runnable {
    var computers: [Computer] = []
    
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
    
    func step() -> Bool {
        var ret = true
        
        computers.forEach {
            if $0.outputs.count >= 3 {
                if $0.outputs[0] == 255 {
                    print("Part 1 result: \($0.outputs[2])")
                    
                    ret = false
                    
                    return
                }
                
                computers[$0.outputs[0]].addInput($0.outputs[1])
                computers[$0.outputs[0]].addInput($0.outputs[2])
                
                $0.clearOutputs()
            }
            
            $0.runSingle()
        }
        
        return ret
    }
}
