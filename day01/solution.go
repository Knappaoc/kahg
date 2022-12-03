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

func nextElf(scanner *bufio.Scanner) (bool, uint) {
	var sum uint = 0
	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if line == "" {
			return true, sum
		} else {
			value, err := strconv.Atoi(line)
			check(err)
			sum += uint(value)
		}
	}
	return false, sum
}

func main() {
	file, err := os.Open("inputs")
	check(err)
	defer file.Close()

	// Stream the contents and collect the totals
	scanner := bufio.NewScanner(file)

	// Accumulator for each elf's total calories.
	acc := make([]uint, 4)

	for more, calories := nextElf(scanner); more; more, calories = nextElf(scanner) {
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
