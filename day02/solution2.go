package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strings"
)

const (
	// Outcomes
	LOSS = 0
	DRAW = 1
	WIN  = 2
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

	var score uint = 0
	for scanner.Scan() {
		tokens := strings.Split(scanner.Text(), " ")

		// Since each choice is just one character, we
		// can just use runes to perform a simple calculation
		// to convert them to points.
		theirChoice := tokens[0][0] - 'A'
		outcome := tokens[1][0] - 'X'

		// Add points from outcome
		score += uint(outcome) * 3

		// Work out my choice from the outcome and the points. +1 since
		// there is at least one point (for rock)
		switch outcome {
		case DRAW:
			score += uint(theirChoice)
		case WIN:
			score += (uint(theirChoice) + 1) % 3
		case LOSS:
			// The points from this is: theirs - 1 + 3 = theirs + 2
			score += (uint(theirChoice) + 2) % 3
		}

		// Score for choices start from 1
		score += 1
	}

	fmt.Println("Score:", score)
}
