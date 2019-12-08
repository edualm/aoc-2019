import Foundation

struct Image {
    enum InitializationError: Error {
        case invalidImageSize
        case malformedData
    }
    
    enum Pixel: Int {
        case black = 0
        case white = 1
        case transparent = 2
        
        var printableCharacter: String {
            if self == .white {
                return "█"
            }
            
            return " "
        }
    }
    
    typealias Layer = [Int]
    
    let layers: [Layer]
    
    let width: Int
    let height: Int
    
    init(fromDSNEncodedData dsn: String, width: Int, height: Int) throws {
        self.width = width
        self.height = height
        
        let layerSize = width * height
        
        if dsn.count % layerSize != 0 {
            throw InitializationError.invalidImageSize
        }
        
        var layers: [Layer] = (0...(dsn.count / layerSize - 1)).map { _ in [] }
        
        for i in 0...(dsn.count - 1) {
            guard let cur = Int(String(dsn[dsn.index(dsn.startIndex, offsetBy: i)])) else {
                throw InitializationError.malformedData
            }
            
            layers[i / layerSize].append(cur)
        }
        
        self.layers = layers
    }
    
    var layeredData: [Pixel] {
        var data: [Pixel] = []
        
        for i in 0...(layers[0].count - 1) {
            let pixelData = layers.map    { Pixel(rawValue: $0[i])! }
                                  .filter { $0 != .transparent }
            
            data.append(pixelData.count > 0 ? pixelData[0] : .transparent)
        }
        
        return data
    }
    
    var asciiString: String {
        let layeredData = self.layeredData
        
        var str = ""
        
        for i in (0...layeredData.count - 1) {
            str += layeredData[i].printableCharacter
            
            if i > 0 && (i + 1) % width == 0 {
                str += "\n"
            }
        }
        
        return str
    }
}

//  Test

guard let testImage = try? Image(fromDSNEncodedData: "123456789012", width: 3, height: 2) else {
    fatalError("Test image initialization failed!")
}

guard testImage.layers == [[1,2,3,4,5,6], [7,8,9,0,1,2]] else {
    fatalError("Unexpected result on test image!")
}

//  Challenge

let challengeImage = try! Image(fromDSNEncodedData: AoCInputData, width: 25, height: 6)

var fewestZeroDigits: (layer: Image.Layer, count: Int)? = nil

for layer in challengeImage.layers {
    let numberOfZeroes = layer.filter { $0 == 0 } .count

    if fewestZeroDigits == nil || fewestZeroDigits!.count > numberOfZeroes {
        fewestZeroDigits = (layer, numberOfZeroes)
    }
}

guard let fzo = fewestZeroDigits else {
    fatalError("Something weird happened.")
}

let result = fzo.layer.filter { $0 == 1 } .count * fzo.layer.filter { $0 == 2 } .count

print("Part 1 answer:")
print("")
print("\(result)")
print("")
print("-----")
print("")
print("Part 2 answer:")
print("")
print(challengeImage.asciiString)
