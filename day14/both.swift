import Foundation

let testInput1 = """
10 ORE => 10 A
1 ORE => 1 B
7 A, 1 B => 1 C
7 A, 1 C => 1 D
7 A, 1 D => 1 E
7 A, 1 E => 1 FUEL
"""

let testInput2 = """
9 ORE => 2 A
8 ORE => 3 B
7 ORE => 5 C
3 A, 4 B => 1 AB
5 B, 7 C => 1 BC
4 C, 1 A => 1 CA
2 AB, 3 BC, 4 CA => 1 FUEL
"""

let testInput3 = """
171 ORE => 8 CNZTR
7 ZLQW, 3 BMBT, 9 XCVML, 26 XMNCP, 1 WPTQ, 2 MZWV, 1 RJRHP => 4 PLWSL
114 ORE => 4 BHXH
14 VRPVC => 6 BMBT
6 BHXH, 18 KTJDG, 12 WPTQ, 7 PLWSL, 31 FHTLT, 37 ZDVW => 1 FUEL
6 WPTQ, 2 BMBT, 8 ZLQW, 18 KTJDG, 1 XMNCP, 6 MZWV, 1 RJRHP => 6 FHTLT
15 XDBXC, 2 LTCX, 1 VRPVC => 6 ZLQW
13 WPTQ, 10 LTCX, 3 RJRHP, 14 XMNCP, 2 MZWV, 1 ZLQW => 1 ZDVW
5 BMBT => 4 WPTQ
189 ORE => 9 KTJDG
1 MZWV, 17 XDBXC, 3 XCVML => 2 XMNCP
12 VRPVC, 27 CNZTR => 2 XDBXC
15 KTJDG, 12 BHXH => 5 XCVML
3 BHXH, 2 VRPVC => 7 MZWV
121 ORE => 7 VRPVC
7 XCVML => 6 RJRHP
5 BHXH, 4 VRPVC => 5 LTCX
"""

func test1() {
    var calculator = Calculator(rules: parseRules(from: testInput1))
    
    try! calculator.generate(chemical: "FUEL")
    
    guard 1_000_000_000_000 - calculator.availableMaterials["ORE"]! == 31 else {
        fatalError("Expected 31, got \(1_000_000_000_000 - calculator.availableMaterials["ORE"]!)")
    }
    
    guard calculator.availableMaterials["FUEL"] == 1 else {
        fatalError("Generated more than 1x fuel!")
    }
}

func test2() {
    var calculator = Calculator(rules: parseRules(from: testInput2))
    
    try! calculator.generate(chemical: "FUEL")
    
    guard 1_000_000_000_000 - calculator.availableMaterials["ORE"]! == 165 else {
        fatalError("Expected 165, got \(1_000_000_000_000 - calculator.availableMaterials["ORE"]!)")
    }
    
    guard calculator.availableMaterials["FUEL"] == 1 else {
        fatalError("Generated more than 1x fuel!")
    }
}

func test3() {
    var calculator = Calculator(rules: parseRules(from: testInput3))
    
    try! calculator.generate(chemical: "FUEL")
    
    guard 1_000_000_000_000 - calculator.availableMaterials["ORE"]! == 2210736 else {
        fatalError("Expected 2210736, got \(1_000_000_000_000 - calculator.availableMaterials["ORE"]!)")
    }
    
    guard calculator.availableMaterials["FUEL"] == 1 else {
        fatalError("Generated more than 1x fuel!")
    }
}

test1()
test2()
test3()

print("All tests ran successfully!")

//  Challenge

let inputChallenge = """
180 ORE => 9 DQFL
3 HGCR, 9 TKRT => 8 ZBLC
1 MZQLG, 12 RPLCK, 8 PDTP => 8 VCFX
3 ZBLC, 19 VFZX => 1 SJQL
1 CRPGK => 4 TPRT
7 HGCR, 4 TGCW, 1 VFZX => 9 JBPHS
8 GJHX => 4 NSDBV
1 VFTG => 2 QNWD
1 WDKW, 2 DWRH, 6 VNMV, 2 HFHL, 55 GJHX, 4 NSDBV, 15 KLJMS, 17 KZDJ => 1 FUEL
2 JHSJ, 15 JNWJ, 1 ZMFXQ => 4 GVRK
1 PJFBD => 3 MZQLG
1 SJQL, 11 LPVWN => 9 DLZS
3 PRMJ, 2 XNWV => 6 JHSJ
4 SJQL => 8 PJFBD
14 QNWD => 6 STHQ
5 CNLFV, 2 VFTG => 9 XNWV
17 LWNKB, 6 KBWF, 3 PLSCB => 8 KZDJ
6 LHWZQ, 5 LWNKB => 3 ZDWX
5 RPLCK, 2 LPVWN => 8 ZMFXQ
1 QNWD, 2 TKRT => 3 CRPGK
1 JBPHS, 1 XNWV => 6 TLRST
21 ZDWX, 3 FZDP, 4 CRPGK => 6 PDTP
1 JCVP => 1 WXDVT
2 CRPGK => 9 FGVL
4 DQFL, 2 VNMV => 1 HGCR
2 GVRK, 2 VCFX, 3 PJFBD, 1 PLSCB, 23 FZDP, 22 PCSM, 1 JLVQ => 6 HFHL
1 CRPGK, 5 PJFBD, 4 XTCP => 8 PLSCB
1 HTZW, 17 FGVL => 3 LHWZQ
2 KBWF => 4 DQKLC
2 LHWZQ => 2 PRMJ
2 DLZS, 2 VCFX, 15 PDTP, 14 ZDWX, 35 NBZC, 20 JVMF, 1 BGWMS => 3 DWRH
2 TKVCX, 6 RPLCK, 2 HTZW => 4 XTCP
8 CNLFV, 1 NRSD, 1 VFTG => 9 VFZX
1 TLRST => 4 WDKW
9 VFCZG => 7 GJHX
4 FZDP => 8 JLVQ
2 ZMFXQ, 2 STHQ => 6 QDZB
2 SJQL, 8 ZDWX, 6 LPRL, 6 WXDVT, 1 TPRT, 1 JNWJ => 8 KLJMS
6 JBPHS, 2 ZBLC => 6 HTZW
1 PDTP, 2 LHWZQ => 8 JNWJ
8 ZBLC => 7 TKVCX
2 WDKW, 31 QDZB => 4 PCSM
15 GJHX, 5 TKVCX => 7 FZDP
15 SJQL, 3 PRMJ => 4 JCVP
31 CNLFV => 1 TGCW
1 TLRST, 2 WDKW => 9 KBWF
102 ORE => 7 VNMV
103 ORE => 5 CNLFV
163 ORE => 2 VFTG
5 NRSD, 1 STHQ => 3 VFCZG
16 LPVWN, 13 KBWF => 2 BGWMS
5 BGWMS, 11 SJQL, 9 FZDP => 6 NBZC
175 ORE => 7 NRSD
5 HTZW => 4 LPVWN
4 PRMJ => 7 JVMF
6 PCSM, 8 DQKLC => 7 LPRL
2 CNLFV => 7 TKRT
3 FZDP => 3 LWNKB
1 HTZW => 4 RPLCK
"""

var calculator = Calculator(rules: parseRules(from: inputChallenge))

try! calculator.generate(chemical: "FUEL")

print("Part 1 answer: \(1_000_000_000_000 - calculator.availableMaterials["ORE"]!)")
print("Part 2 answer: \(solveSecond(inputChallenge: inputChallenge))")
