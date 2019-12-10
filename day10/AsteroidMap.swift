import Foundation

public struct AsteroidMap {
    var map: [[Double]]
    
    var asteroidPositions: [Coordinate] {
        var coordinates: [Coordinate] = []
        
        for y in 0...(map.count - 1) {
            for x in 0...(map[y].count - 1) {
                if map[y][x] == 1 {
                    coordinates.append(Coordinate(x: Double(x), y: Double(y)))
                }
            }
        }
        
        return coordinates
    }
    
    public init(fromStringRepresentation mapAsString: String) {
        map = mapAsString.split(separator: "\n")
            .map { $0.map({ $0 == "#" ? 1 : 0 }) }
    }
    
    public func visibleAsteroids(from station: Coordinate) -> [Coordinate] {
        let cachedAsteroidPositions = asteroidPositions
        
        var visibleAsteroidCoordinates: [Coordinate] = []
        
        for otherAsteroid in asteroidPositions {
            guard otherAsteroid != station else { continue }
            
            let stepIncrease = station.stepIncrease(to: otherAsteroid)
            
            var currentCoordinate = station
            
            var success = true
            
            while currentCoordinate != otherAsteroid {
                currentCoordinate = currentCoordinate + stepIncrease
                
                //  Decimals are hard, am I right?
                
                if abs(currentCoordinate.x.truncatingRemainder(dividingBy: 1)) < 0.00001 || abs(currentCoordinate.x.truncatingRemainder(dividingBy: 1)) > 0.99999 {
                    currentCoordinate = Coordinate(x: currentCoordinate.x.rounded(),
                                                   y: currentCoordinate.y)
                }
                
                if abs(currentCoordinate.y.truncatingRemainder(dividingBy: 1)) < 0.00001 || abs(currentCoordinate.y.truncatingRemainder(dividingBy: 1)) > 0.99999 {
                    currentCoordinate = Coordinate(x: currentCoordinate.x,
                                                   y: currentCoordinate.y.rounded())
                }
                
                if currentCoordinate == otherAsteroid {
                    break
                }
                
                if cachedAsteroidPositions.contains(currentCoordinate) {
                    success = false
                    
                    break
                }
            }
            
            if success {
                visibleAsteroidCoordinates.append(otherAsteroid)
            }
        }
        
        return visibleAsteroidCoordinates
    }
    
    public mutating func vaporize(from station: Coordinate) -> [Coordinate] {
        var vaporized: [Coordinate] = []
        
        while true {
            let inner = vaporizeOneStep(from: station)
            
            guard inner.count != 0 else { break }
            
            vaporized += inner
        }
        
        return vaporized
    }
    
    public mutating func vaporizeOneStep(from station: Coordinate) -> [Coordinate] {
        let toVaporize = visibleAsteroids(from: station)
            .map { ($0, angle(between: station, and: $0)) }
            .sorted { $0.1 < $1.1 }
            .map { $0.0 }
        
        toVaporize.forEach {
            map[Int($0.y)][Int($0.x)] = 0
        }
        
        return toVaporize
    }
    
    public var bestStationLocation: Coordinate {
        var best: (Coordinate, Int)?
        
        for station in asteroidPositions {
            let visibleAsteroidCount = visibleAsteroids(from: station).count
            
            if best == nil || best!.1 < visibleAsteroidCount {
                best = (station, visibleAsteroidCount)
            }
        }
        
        return best!.0
    }
}

public func angle(between station: Coordinate, and asteroid: Coordinate) -> Double {
    var radians = atan2(asteroid.x - station.x, station.y - asteroid.y)
    
    if radians < 0 {
        radians += .pi * 2.0
    }
    
    return radians
}
