package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
	"strings"
)

type Range struct {
	Start uint64
	End   uint64
}

func (r *Range) isSubset(other *Range) bool {
	return (r.Start <= other.Start && other.End <= r.End) ||
		(other.Start <= r.Start && r.End <= other.End)
}

func (r *Range) isDisjoint(other *Range) bool {
	return (other.Start < r.Start && other.End < r.Start) ||
		(r.End < other.Start && r.End < other.End)
}

func check(err error) {
	if err != nil {
		log.Fatalf("Error: %v\n", err)
	}
}

func parsePair(content string) (Range, Range) {
	tokens := strings.Split(content, ",")
	return parseRange(tokens[0]), parseRange(tokens[1])
}

func parseRange(pair string) Range {
	tokens := strings.Split(pair, "-")
	var start, end int
	var err error

	start, err = strconv.Atoi(tokens[0])
	check(err)

	end, err = strconv.Atoi(tokens[1])
	check(err)

	return Range{
		Start: uint64(start),
		End:   uint64(end),
	}
}

func main() {
	file, err := os.Open("input")
	check(err)
	defer file.Close()

	scanner := bufio.NewScanner(file)

	var subsetCount, anyOverlap uint = 0, 0
	for scanner.Scan() {
		line := scanner.Text()

		elf1, elf2 := parsePair(line)
		if elf1.isSubset(&elf2) {
			subsetCount++
		}
		if !elf1.isDisjoint(&elf2) {
			anyOverlap++
		}
	}
	fmt.Printf("Subset count: %v\n", subsetCount)
	fmt.Printf("Any overlap count: %v\n", anyOverlap)
}
