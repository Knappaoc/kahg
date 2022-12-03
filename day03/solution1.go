package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strings"
)

func check(err error) {
	if err != nil {
		log.Fatalf("Error: %v\n", err)
	}
}

func main() {
	file, err := os.Open("input")
	check(err)
	defer file.Close()

	scanner := bufio.NewScanner(file)

	var sum uint = 0
	for scanner.Scan() {
		line := scanner.Text()
		length := len(line)

		left := line[:length/2]
		right := line[length/2:]

		// Track seen items to avoid counting an item twice
		seen := make(map[rune]bool)

		for _, item := range left {
			if !seen[item] {
				if strings.ContainsRune(right, item) {
					if 'a' <= item && item <= 'z' {
						sum += uint(item - 'a' + 1)
					} else if 'A' <= item && item <= 'Z' {
						sum += uint(item - 'A' + 27)
					}
				}
				seen[item] = true
			}
		}
	}
	fmt.Printf("Sum: %v\n", sum)
}
