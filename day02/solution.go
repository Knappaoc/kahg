package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
)

func check(err error) {
	if err != nil {
		log.Fatalf("Error: %v\n", err)
	}
}

func main() {
	file, err := os.Open("inputs")
	check(err)
	defer file.Close()

	scanner := bufio.NewScanner(file)

	var part1, part2 uint
	var read int
	var leftRune, rightRune rune
	for scanner.Scan() {
		read, err = fmt.Sscanf(scanner.Text(), "%c %c", &leftRune, &rightRune)
		check(err)
		if read != 2 {
			log.Fatalf("Expected 2 items read, got %d\n", read)
		}

		left := uint(leftRune - 'A')
		right := uint(rightRune - 'X')

		// For part 1, treating right as our choice,
		// we "win" if our choice is the "next one up"
		// and "lose" if our choice is the "one before"...
		part1 += (right + 1) + 3*((right-left+4)%3)

		// For part 2, we get back to our choice by moving
		// back up or down depending on outcome
		part2 += right*3 + ((right - 1 + left + 3) % 3) + 1
	}

	fmt.Printf("Part 1: %v\n", part1)
	fmt.Printf("Part 2: %v\n", part2)
}
