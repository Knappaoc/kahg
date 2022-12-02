package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strings"
)

var order = "ABCA"

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
		theirChoice := tokens[0][0]
		myChoice := tokens[1][0] - 'X' + 'A'

		// Add points from selection. +1 since points start
		// at 1, not 0.
		score += uint(myChoice-'A') + 1

		// Add points from result
		if theirChoice == myChoice {
			// Draw
			score += 3
		} else {
			theirIndex := strings.IndexByte(order, theirChoice)
			mineIndex := strings.LastIndexByte(order, myChoice)
			if theirIndex+1 == mineIndex {
				// This means I've won
				score += 6
			}
			// otherwise, we lose
		}
	}

	fmt.Println("Score:", score)
}
