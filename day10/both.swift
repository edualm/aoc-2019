import Foundation

//  Tests

let input1 = """
.#..#
.....
#####
....#
...##
"""

let asteroidMap1 = AsteroidMap(fromStringRepresentation: input1)

guard asteroidMap1.visibleAsteroids(from: Coordinate(x: 3, y: 4)).count == 8 else {
    fatalError()
}

let input2 = """
......#.#.
#..#.#....
..#######.
.#.#.###..
.#..#.....
..#....#.#
#..#....#.
.##.#..###
##...#..#.
.#....####
"""

let asteroidMap2 = AsteroidMap(fromStringRepresentation: input2)

guard asteroidMap2.visibleAsteroids(from: Coordinate(x: 5, y: 8)).count == 33 else {
    fatalError()
}

let input3 = """
.#..##.###...#######
##.############..##.
.#.######.########.#
.###.#######.####.#.
#####.##.#.##.###.##
..#####..#.#########
####################
#.####....###.#.#.##
##.#################
#####.##.###..####..
..######..##.#######
####.##.####...##..#
.#####..#.######.###
##...#.##########...
#.##########.#######
.####.#.###.###.#.##
....##.##.###..#####
.#.#.###########.###
#.#.#.#####.####.###
###.##.####.##.#..##
"""

var asteroidMap3 = AsteroidMap(fromStringRepresentation: input3)

guard asteroidMap3.visibleAsteroids(from: Coordinate(x: 11, y: 13)).count == 210 else {
    fatalError()
}

//  Self tests

guard asteroidMap1.bestStationLocation == Coordinate(x: 3, y: 4) else {
    fatalError()
}

guard asteroidMap2.bestStationLocation == Coordinate(x: 5, y: 8) else {
    fatalError()
}

guard asteroidMap3.bestStationLocation == Coordinate(x: 11, y: 13) else {
    fatalError()
}

let vaporizedMap3 = asteroidMap3.vaporize(from: Coordinate(x: 11, y: 13))

guard vaporizedMap3[0] == Coordinate(x: 11, y: 12) else {
    fatalError()
}

guard vaporizedMap3[1] == Coordinate(x: 12, y: 1) else {
    fatalError()
}

guard vaporizedMap3[2] == Coordinate(x: 12, y: 2) else {
    fatalError()
}

guard vaporizedMap3[198] == Coordinate(x: 9, y: 6) else {
    fatalError()
}

guard vaporizedMap3[200] == Coordinate(x: 10, y: 9) else {
    fatalError()
}

guard vaporizedMap3[298] == Coordinate(x: 11, y: 1) else {
    fatalError()
}


//  Challenge

let challengeInput = """
#..#.#.#.######..#.#...##
##.#..#.#..##.#..######.#
.#.##.#..##..#.#.####.#..
.#..##.#.#..#.#...#...#.#
#...###.##.##..##...#..#.
##..#.#.#.###...#.##..#.#
###.###.#.##.##....#####.
.#####.#.#...#..#####..#.
.#.##...#.#...#####.##...
######.#..##.#..#.#.#....
###.##.#######....##.#..#
.####.##..#.##.#.#.##...#
##...##.######..##..#.###
...###...#..#...#.###..#.
.#####...##..#..#####.###
.#####..#.#######.###.##.
#...###.####.##.##.#.##.#
.#.#.#.#.#.##.#..#.#..###
##.#.####.###....###..##.
#..##.#....#..#..#.#..#.#
##..#..#...#..##..####..#
....#.....##..#.##.#...##
.##..#.#..##..##.#..##..#
.##..#####....#####.#.#.#
#..#..#..##...#..#.#.#.##
"""

var challengeMap = AsteroidMap(fromStringRepresentation: challengeInput)

print("Part 1 answer: \(challengeMap.visibleAsteroids(from: challengeMap.bestStationLocation).count)")

let vaporized = challengeMap.vaporize(from: challengeMap.bestStationLocation)

print("Part 2 answer: \(vaporized[199].x * 100 + vaporized[199].y)")
