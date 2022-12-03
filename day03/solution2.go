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

func nextLine(scanner *bufio.Scanner) string {
	if !scanner.Scan() {
		log.Fatal("Out of content")
	}
	return scanner.Text()
}

func main() {
	file, err := os.Open("input")
	check(err)
	defer file.Close()

	scanner := bufio.NewScanner(file)

	var sum uint = 0
	for scanner.Scan() {
		elf1 := scanner.Text()
		elf2 := nextLine(scanner)
		elf3 := nextLine(scanner)

		seen := make(map[rune]bool)

		for _, item := range elf1 {
			if !seen[item] {
				if strings.ContainsRune(elf2, item) && strings.ContainsRune(elf3, item) {

					if 'a' <= item && item <= 'z' {
						sum += uint(item - 'a' + 1)
					} else if 'A' <= item && item <= 'Z' {
						sum += uint(item - 'A' + 27)
					}

					// Assuming each group has only one item in common, we can simply go on
					// to the next group.
					break
				}
				seen[item] = true
			}
		}
	}

	fmt.Printf("Sum: %v\n", sum)
}
