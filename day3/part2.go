package main

import (
	"fmt"
	"io/ioutil"
	"math"
	"strconv"
	"strings"
)

type point struct {
	x int
	y int
}

type vector struct {
	direction string
	length    int
}

type pointWithSteps struct {
	p point
	s int
}

func intersection(a, b []point) []pointWithSteps {
	var ret []pointWithSteps

	for i := 0; i < len(a); i++ {
		for j := 0; j < len(b); j++ {
			point1 := a[i]
			point2 := b[j]

			if point1.x == point2.x && point1.y == point2.y {
				ret = append(ret, pointWithSteps{
					p: point1,
					s: i + j,
				})
			}
		}
	}

	return ret
}

func partToVector(part string) vector {
	directionStr := string(part[0])
	lengthStr := string(part[1:])

	length, _ := strconv.Atoi(lengthStr)

	return vector{
		direction: directionStr,
		length:    length,
	}
}

func buildBoard(vectors []vector) []point {
	currentPoint := point{
		x: 0,
		y: 0,
	}

	var board []point

	for i := 0; i < len(vectors); i++ {
		currentVector := vectors[i]

		switch currentVector.direction {
		case "R":
			for j := 1; j <= currentVector.length; j++ {
				currentPoint = point{
					x: currentPoint.x + 1,
					y: currentPoint.y,
				}

				board = append(board, currentPoint)
			}

			break
		case "L":
			for j := 1; j <= currentVector.length; j++ {
				currentPoint = point{
					x: currentPoint.x - 1,
					y: currentPoint.y,
				}

				board = append(board, currentPoint)
			}

			break
		case "U":
			for j := 1; j <= currentVector.length; j++ {
				currentPoint = point{
					x: currentPoint.x,
					y: currentPoint.y + 1,
				}

				board = append(board, currentPoint)
			}

			break
		case "D":
			for j := 1; j <= currentVector.length; j++ {
				currentPoint = point{
					x: currentPoint.x,
					y: currentPoint.y - 1,
				}

				board = append(board, currentPoint)
			}

			break
		}
	}

	return board
}

func test() error {
	result := run("R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83")

	if result != 610 {
		return fmt.Errorf("result should equal 610, got %d instead, bailing out", result)
	}

	result = run("R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\nU98,R91,D20,R16,D67,R40,U7,R15,U6,R7")

	if result != 410 {
		return fmt.Errorf("result should equal 410, got %d instead, bailing out", result)
	}

	return nil
}

func leastSteps(ps []pointWithSteps) int {
	lowest := math.MaxInt64

	for i := 0; i < len(ps); i++ {
		if lowest > ps[i].s {
			lowest = ps[i].s
		}
	}

	return lowest
}

func run(data string) int {
	allRows := strings.Split(string(data), "\n")

	var allVectors [][]vector

	for i := 0; i < len(allRows); i++ {
		parts := strings.Split(allRows[i], ",")

		var rowVectors []vector

		for j := 0; j < len(parts); j++ {
			rowVectors = append(rowVectors, partToVector(parts[j]))
		}

		allVectors = append(allVectors, rowVectors)
	}

	intersection := intersection(buildBoard(allVectors[0]), buildBoard(allVectors[1]))

	return leastSteps(intersection) + 2
}

func main() {
	err := test()

	if err != nil {
		fmt.Println(err)

		return
	}

	print("All tests passing!\n")

	data, err := ioutil.ReadFile("input.txt")

	if err != nil {
		panic(err)
	}

	result := run(string(data))

	print(result)
}
