package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"sort"
	"strconv"
	"strings"
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

	// Stream the contents and collect the totals
	scanner := bufio.NewScanner(file)

	// When true, we are in the middle of an elf's entries
	// as we read each calory. False when we are waiting
	// for the next elf.
	grouping := false

	// This value is tracking an individual elf's
	var calories uint = 0

	// Accumulator for each elf's total calories.
	acc := make([]uint, 0)
	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if line == "" {
			if grouping {
				grouping = false
				acc = append(acc, calories)
				calories = 0
			}
		} else {
			var value int
			value, err := strconv.Atoi(line)
			check(err)
			calories += uint(value)
			grouping = true
		}
	}

	// In case the inputs don't end with an empty line!
	if grouping {
		acc = append(acc, calories)
	}

	// Sort the accumulator in descending order
	sort.Slice(acc, func(i, j int) bool {
		return acc[i] > acc[j]
	})

	// Part 1: Highest sum overall
	fmt.Printf("Highest value: %v\n", acc[0])

	// Part 2: Sum of highest 3.
	var sum uint = 0
	for _, v := range acc[0:3] {
		sum += v
	}
	fmt.Printf("Sum of top 3: %v\n", sum)
}
