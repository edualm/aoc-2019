import Foundation

let basePattern = [0, 1, 0, -1]

func convert(input: String) -> [Int] {
    return input.map {
        return Int(String($0))!
    }
}

func generateResult(from input: [Int], digits: Int = 8) -> String {
    return input.prefix(digits).reduce(into: "", { result, current in result += "\(current)" } )
}

let test1Input = convert(input: "80871224585914546619083218645595")
var test1Output = test1Input
let test1FFT = FFT(pattern: basePattern)

for _ in 0...99 {
    test1Output = test1FFT.operate(on: test1Output)
}

print("Test 1 output: \(generateResult(from: test1Output))")

//  Challenge!

let challengeInput = convert(input: "59713137269801099632654181286233935219811755500455380934770765569131734596763695509279561685788856471420060118738307712184666979727705799202164390635688439701763288535574113283975613430058332890215685102656193056939765590473237031584326028162831872694742473094498692690926378560215065112055277042957192884484736885085776095601258138827407479864966595805684283736114104361200511149403415264005242802552220930514486188661282691447267079869746222193563352374541269431531666903127492467446100184447658357579189070698707540721959527692466414290626633017164810627099243281653139996025661993610763947987942741831185002756364249992028050315704531567916821944")

var challengeOutput = challengeInput

for _ in 0...99 {
    challengeOutput = test1FFT.operate(on: challengeOutput)
}

print("Part 1 answer: \(generateResult(from: challengeOutput))")

//  Part 2 - Test

let test2Input = (0...9999).reduce(into: [] as [Int]) { result, _ in result += challengeInput }
var test2Output = test2Input

let offset = Int(generateResult(from: test2Input, digits: 7))!

let test2FFT = FFT(pattern: basePattern)

test2Output = Array(test2Output.dropFirst(offset))

for _ in 0...99 {
    test2Output = test2FFT.operateWithOffset(on: test2Output)
}

print("Test 2 output: \(generateResult(from: test2Output))")
