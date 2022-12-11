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

type Monkey struct {
	Items     []uint
	WorryFn   func(uint) uint
	Divisor   uint
	Next      [2]int
	Inspected int
}

func main() {
	file, err := os.Open("input")
	check(err)
	defer file.Close()

	monkies := make([]Monkey, 0)
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		content := strings.TrimSpace(scanner.Text())
		if strings.HasPrefix(content, "Monkey") {
			monkies = append(monkies, parseMonkey(scanner))
		}
	}

	// Find the common demoninator between the monkeys.
	// If we rebase the worry level to this, then we can
	// track just the remainder from dividing by this number.
	// No need for big Int!
	cd := uint(1)
	for i, m := range monkies {
		if cd%m.Divisor != 0 {
			cd = cd * m.Divisor
		}
		fmt.Printf("Monkey %v: Items=%v, Div=%v, Next=%v\n", i, m.Items, m.Divisor, m.Next)
	}

	fmt.Printf("Common denominator: %v\n", cd)
	for round := 0; round < 10000; round++ {
		nRound := round + 1
		runRound(monkies, cd)
		if nRound == 20 || nRound%1000 == 0 {
			fmt.Printf("Round %v *****\n", nRound)

			for i, m := range monkies {
				fmt.Printf("  Monkey %v: Items=%v, Inspected=%v\n", i, m.Items, m.Inspected)
			}
		}
	}

	sort.Slice(monkies, func(i, j int) bool {
		return monkies[i].Inspected < monkies[j].Inspected
	})

	monkeyA := monkies[len(monkies)-2]
	monkeyB := monkies[len(monkies)-1]

	fmt.Printf("Result: %v\n", monkeyA.Inspected*monkeyB.Inspected)
}

func check(err error) {
	if err != nil {
		log.Fatalf("Error: %v\n", err)
	}
}

func parseMonkey(scanner *bufio.Scanner) Monkey {
	// Going to cheat by assuming order
	starting := nextLine(scanner)[2:]
	startItems := make([]uint, len(starting))

	for i, v := range starting {
		startItems[i] = uint(parseInt(strings.Trim(v, ",")))
	}

	operationContent := nextLine(scanner)
	opFactorText := operationContent[5]
	opOperator := operationContent[4]
	var operation func(uint) uint
	if opFactorText == "old" {
		switch opOperator {
		case "+":
			operation = func(i uint) uint { return (i + i) }
		case "*":
			operation = func(i uint) uint { return (i * i) }
		default:
			panic("unrecognised operation: " + opOperator)
		}
	} else {
		opFactor := uint(parseInt(operationContent[5]))

		switch opOperator {
		case "+":
			operation = func(i uint) uint { return (i + opFactor) }
		case "*":
			operation = func(i uint) uint { return (i * opFactor) }
		default:
			panic("unrecognised operation: " + opOperator)
		}
	}

	divisorContent := nextLine(scanner)
	divisor := uint(parseInt(divisorContent[3]))

	trueContent := nextLine(scanner)
	nextTrue := parseInt(trueContent[5])

	falseContent := nextLine(scanner)
	nextFalse := parseInt(falseContent[5])

	return Monkey{
		Items:     startItems,
		WorryFn:   operation,
		Divisor:   divisor,
		Next:      [2]int{nextTrue, nextFalse},
		Inspected: 0,
	}
}

func nextLine(scanner *bufio.Scanner) []string {
	if !scanner.Scan() {
		panic("out of content")
	}
	line := strings.TrimSpace(scanner.Text())
	return strings.Fields(line)
}

func parseInt(content string) int {
	result, err := strconv.Atoi(strings.TrimSpace(content))
	if err != nil {
		panic(err)
	}
	return result
}

func runRound(monkies []Monkey, cd uint) {
	for i := range monkies {
		runMonkey(monkies, i, cd)
	}
}

func runMonkey(monkies []Monkey, i int, cd uint) {
	monkey := &monkies[i]
	monkey.Inspected += len(monkey.Items)
	for _, v := range monkey.Items {
		worry := monkey.WorryFn(v) % cd
		var next int
		if worry%monkey.Divisor == 0 {
			next = monkey.Next[0]
		} else {
			next = monkey.Next[1]
		}

		nextMonkey := &monkies[next]
		nextMonkey.Items = append(nextMonkey.Items, worry)
	}
	monkies[i].Items = make([]uint, 0)
}
