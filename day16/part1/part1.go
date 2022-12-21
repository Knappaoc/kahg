package part1

import (
	"sort"

	"github.com/kahgoh/aoc/day16/puzzle"
)

type Option struct {
	Valves []*puzzle.Valve
	Score  int
}

func Solve(valves map[string]*puzzle.Valve) Option {
	start := valves["AA"]

	ofInterest := make(map[*puzzle.Valve]bool)
	for _, r := range start.Routes {
		ofInterest[r.Valve] = true
	}

	return optimize(start, ofInterest, 30)
}

func optimize(from *puzzle.Valve, remaining map[*puzzle.Valve]bool, budget int) Option {
	rem := copyMap(remaining)
	delete(rem, from)

	// Remaining budget. Note we need to spend 1 minute to open valve
	// if flow > 0
	remBudget := budget
	if from.Flow > 0 {
		remBudget = budget - 1
	}

	scores := make([]Option, 0)
	for _, route := range from.Routes {
		if rem[route.Valve] && route.Distance < remBudget {
			candidate := optimize(route.Valve, rem, remBudget-route.Distance)
			scores = append(scores, candidate)
		}
	}

	scoreFromNode := from.Flow * remBudget
	if len(scores) == 0 {
		return Option{Valves: []*puzzle.Valve{from}, Score: scoreFromNode}
	}

	sort.Slice(scores, func(i, j int) bool { return scores[i].Score < scores[j].Score })

	selection := scores[len(scores)-1]
	thisScore := selection.Score + scoreFromNode
	return Option{Valves: append(selection.Valves, from), Score: thisScore}
}

func copyMap(source map[*puzzle.Valve]bool) map[*puzzle.Valve]bool {
	copy := make(map[*puzzle.Valve]bool)
	for k, v := range source {
		copy[k] = v
	}
	return copy
}
