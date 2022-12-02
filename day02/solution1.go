package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strings"
)

const (
	ROCK     = 0
	PAPER    = 1
	SCISSORS = 2
)

// Map from their choice to the choice I need to make
// to win
var choiceToWin = map[byte]byte{
	ROCK:     PAPER,
	PAPER:    SCISSORS,
	SCISSORS: ROCK,
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
		myChoice := tokens[1][0] - 'X'

		// Add points from selection. +1 since points start
		// at 1, not 0.
		score += uint(myChoice) + 1

		// Add points from result
		if theirChoice == myChoice {
			// Draw
			score += 3
		} else if choiceToWin[theirChoice] == myChoice {
			// Win
			score += 6
		}
		// No score for loss
	}

	fmt.Println("Score: ", score)
}
