package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strings"
)

func main() {
	file, err := os.Open("input")
	check(err)
	defer file.Close()

	register := make([]int, 1)
	register[0] = 1
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		content := strings.TrimSpace(scanner.Text())
		last := register[len(register)-1]
		register = append(register, last)

		var amount int = 0
		_, err = fmt.Sscanf(content, "addx %d", &amount)
		if err == nil {
			register = append(register, last+amount)
		}
		// else, its not an addx instruction
	}

	fmt.Printf("20=%v, 60=%v, 100=%v, 140=%v, 180=%v, 220=%v\n", register[19], register[59], register[99], register[139], register[179], register[219])
	sum := 0
	for _, i := range []int{20, 60, 100, 140, 180, 220} {
		sum += register[i-1] * i
	}
	fmt.Printf("part 1 sum: %v\n", sum)

	nRows := 6
	nCols := 40
	pixMap := make([][]bool, nRows)
	for i := 0; i < len(pixMap); i++ {
		pixMap[i] = make([]bool, nCols)
	}

	for i := 0; i < 240; i++ {
		row := (i / nCols) % nRows
		col := i % nCols

		pixMap[row][col] = register[i]-1 <= col && col <= register[i]+1
	}

	for _, cRow := range pixMap {
		for _, cCol := range cRow {
			if cCol {
				fmt.Print("#")
			} else {
				fmt.Print(" ")
			}
		}
		fmt.Print("\n")
	}
}

func check(err error) {
	if err != nil {
		log.Fatalf("Error: %v\n", err)
	}
}
