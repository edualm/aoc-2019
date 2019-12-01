package main

import (
	"errors"
	"io/ioutil"
	"math"
	"strconv"
	"strings"
)

func fuelSingle(mass int64) int64 {
	return int64(math.Floor(float64(mass)/3.0)) - 2
}

func fuel(mass int64) int64 {
	f := fuelSingle(mass)

	accum := f

	for fuelSingle(f) > 0 {
		f = fuelSingle(f)
		accum += f
	}

	return accum
}

func test() error {
	if fuel(12) != 2 {
		return errors.New("fuel(12) should equal 2, bailing out")
	}

	if fuel(14) != 2 {
		return errors.New("fuel(14) should equal 2, bailing out")
	}

	if fuel(1969) != 966 {
		return errors.New("fuel(1969) should equal 966, bailing out")
	}

	if fuel(100756) != 50346 {
		return errors.New("fuel(100756) should equal 50346, bailing out")
	}

	return nil
}

func main() {
	err := test()

	if err != nil {
		print(err)

		return
	}

	data, err := ioutil.ReadFile("input.txt")

	if err != nil {
		panic(err)
	}

	allRows := strings.Split(string(data), "\n")

	var accum int64
	accum = 0

	for i := 0; i < len(allRows); i++ {
		row, _ := strconv.ParseInt(allRows[i], 10, 64)

		accum += fuel(row)
	}

	print(accum)
}
