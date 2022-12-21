package part2

import (
	"github.com/kahgoh/aoc/day16/puzzle"
)

func Solve(valves map[string]*puzzle.Valve, budget int) ([]*puzzle.Valve, []*puzzle.Valve, int) {
	start := valves["AA"]

	ofInterest := make(map[*puzzle.Valve]bool)
	for _, r := range start.Routes {
		ofInterest[r.Valve] = true
	}

	maxScore := 0
	maxLeft := make([]*puzzle.Valve, 0)
	maxRight := make([]*puzzle.Valve, 0)

	options := optimize(start, Accumulator{Ancestors: make([]*puzzle.Valve, 0), Score: 0}, ofInterest, budget)
	for left := 0; left < len(options)-1; left = left + 1 {
		for right := left + 1; right < len(options); right = right + 1 {
			leftOp := options[left]
			rightOp := options[right]

			candidateScore := leftOp.Score + rightOp.Score
			if maxScore < candidateScore && puzzle.AreDisjoint(leftOp, rightOp) {
				maxLeft = leftOp.Path
				maxRight = rightOp.Path
				maxScore = candidateScore
			}
		}
	}

	return maxLeft, maxRight, maxScore
}

func optimize(from *puzzle.Valve, acc Accumulator, remaining map[*puzzle.Valve]bool, budget int) []puzzle.Option {
	rem := copyMap(remaining)
	delete(rem, from)

	// Remaining budget. Note we need to spend 1 minute to open valve
	// if flow > 0
	remBudget := budget
	if from.Flow > 0 {
		remBudget = budget - 1
	}

	scoreFromNode := from.Flow * remBudget
	newAcc := acc.AddScore(from, scoreFromNode)
	var options []puzzle.Option = make([]puzzle.Option, 1)
	options[0] = puzzle.Option{
		Path:  newAcc.Ancestors,
		Score: newAcc.Score,
	}

	for _, route := range from.Routes {
		if rem[route.Valve] && route.Distance < remBudget {
			subOptions := optimize(route.Valve, newAcc, rem, remBudget-route.Distance)
			options = append(options, subOptions...)
		}
	}

	return options
}

func copyMap(source map[*puzzle.Valve]bool) map[*puzzle.Valve]bool {
	copy := make(map[*puzzle.Valve]bool)
	for k, v := range source {
		copy[k] = v
	}
	return copy
}
