package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
	"strings"
)

const COLUMN_WIDTH = 4

type Stacks []string

func check(err error) {
	if err != nil {
		log.Fatalf("Error: %v\n", err)
	}
}

func readStartMap(scanner *bufio.Scanner) Stacks {
	scanner.Scan()
	line := scanner.Text()
	buffer := make([]string, 0)

	columnCount := countColumns(line)
	// This parsing puts the last element at the front of the slice
	for columnCount < 0 {
		buffer = append(buffer, line)
		if !scanner.Scan() {
			log.Fatalln("out of content")
		}
		line = scanner.Text()
		columnCount = countColumns(line)
	}

	startMap := make([]string, columnCount)
	for _, content := range buffer {
		for i := 0; i < columnCount; i++ {
			crate := content[i*COLUMN_WIDTH+1]
			if crate != ' ' {
				startMap[i] = startMap[i] + string(crate)
			}
		}
	}

	return Stacks(startMap)
}

func countColumns(line string) int {
	fields := strings.Fields(line)
	for i, token := range fields {
		value, err := strconv.Atoi(token)
		if err != nil || value != i+1 {
			return -1
		}
	}
	return len(fields)
}

func reverse(content string) string {
	result := []byte(content)
	for i, j := 0, len(result)-1; i < j; i, j = i+1, j-1 {
		result[i], result[j] = result[j], result[i]
	}
	return string(result)
}

func (stacks Stacks) move(n, src, dest int, fn func(string) string) {
	stacks[dest] = fn(stacks[src][0:n]) + stacks[dest]
	stacks[src] = stacks[src][n:]
}

func main() {
	file, err := os.Open("input")
	check(err)
	defer file.Close()

	scanner := bufio.NewScanner(file)
	crane1 := readStartMap(scanner)
	crane2 := make(Stacks, len(crane1))
	copy(crane2, crane1)

	fmt.Printf("Starting stack is: %v\n", crane1)

	// Find the the first instruction
	scanner.Scan()

	// Parse the instructions
	for scanner.Scan() {
		line := scanner.Text()

		var n, src, dest int = 0, 0, 0

		read, err := fmt.Sscanf(line, "move %d from %d to %d", &n, &src, &dest)
		check(err)
		if read < 3 {
			log.Fatalf("Expected 3 items to be parsed, got %d\n", read)
		}

		crane1.move(n, src-1, dest-1, reverse)
		crane2.move(n, src-1, dest-1, func(x string) string { return x })
	}
	fmt.Printf("Crane 9000: %v\n", crane1)
	fmt.Printf("Crane 9001: %v\n", crane2)
}
