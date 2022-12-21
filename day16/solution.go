package main

import (
	"log"
	"strings"

	"github.com/kahgoh/aoc/day16/part1"
	"github.com/kahgoh/aoc/day16/part2"
	"github.com/kahgoh/aoc/day16/puzzle"
)

func main() {
	valves := puzzle.ReadInput("input")
	ofInterest := make([]*puzzle.Valve, 0)

	// Find valves with points. They are the ones that we are
	// interested in.
	for _, v := range valves {
		if v.Flow > 0 {
			ofInterest = append(ofInterest, v)
		}
	}

	// Now for each one of interest, calculate shortest distance
	// between them.
	valves["AA"].FindRoutes(ofInterest)
	for _, v := range ofInterest {
		v.FindRoutes(ofInterest)
	}

	best := part1.Solve(valves)
	path := make([]string, len(best.Valves))
	for i, v := range best.Valves {
		path[len(best.Valves)-1-i] = v.Name
	}
	// Part 1:
	log.Printf("Path: %s\n", strings.Join(path, " -> "))
	log.Printf("Max score: %d\n", best.Score)

	// Part 2:
	leftPath, rightPath, maxScore := part2.Solve(valves, 26)
	log.Printf("Left:  %s\n", pathToString(leftPath))
	log.Printf("Right: %s\n", pathToString(rightPath))
	log.Printf("Max score: %d\n", maxScore)
}

func pathToString(path []*puzzle.Valve) string {
	names := make([]string, len(path))
	for i, v := range path {
		names[i] = v.Name
	}
	return strings.Join(names, " -> ")
}
