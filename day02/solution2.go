package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strings"
)

const (
	// Choices
	ROCK     = 0
	PAPER    = 1
	SCISSORS = 2

	// Outcomes
	LOSS = 0
	DRAW = 1
	WIN  = 2
)

// Map from their choice, to the desired outcome and
// then the required choice to get that desired outcome.
var theirsToMineRequired = map[byte]map[byte]byte{
	ROCK: {
		LOSS: SCISSORS,
		DRAW: ROCK,
		WIN:  PAPER,
	},
	PAPER: {
		LOSS: ROCK,
		DRAW: PAPER,
		WIN:  SCISSORS,
	},
	SCISSORS: {
		LOSS: PAPER,
		DRAW: SCISSORS,
		WIN:  ROCK,
	},
}

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
		score += uint(theirsToMineRequired[theirChoice][outcome]) + 1
	}

	fmt.Println("Score: ", score)
}
