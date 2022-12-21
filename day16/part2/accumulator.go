package part2

import (
	"github.com/kahgoh/aoc/day16/puzzle"
)

type Accumulator struct {
	Ancestors []*puzzle.Valve
	Score     int
}

func (acc Accumulator) AddScore(valve *puzzle.Valve, score int) Accumulator {
	clone := Accumulator{
		Ancestors: make([]*puzzle.Valve, len(acc.Ancestors)+1),
		Score:     acc.Score + score,
	}

	copy(clone.Ancestors, acc.Ancestors)
	clone.Ancestors[len(acc.Ancestors)] = valve

	return clone
}
