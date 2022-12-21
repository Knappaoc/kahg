package main

import (
	"testing"

	"github.com/kahgoh/aoc/day16/puzzle"
)

var nameToValve = make(map[string]*puzzle.Valve)

func TestParse(t *testing.T) {
	valveAA := puzzle.Parse("Valve AA has flow rate=0; tunnels lead to valves DD, II, BB", nameToValve)
	valveBB := puzzle.Parse("Valve BB has flow rate=13; tunnels lead to valves CC, AA", nameToValve)
	valveCC := puzzle.Parse("Valve CC has flow rate=2; tunnels lead to valves DD, BB", nameToValve)

	expect(t, "AA", valveAA, 0, 3)
	expect(t, "BB", valveBB, 13, 2)
	expect(t, "CC", valveCC, 2, 2)
}

func TestParseOneConnection(t *testing.T) {
	valveJJ := puzzle.Parse("Valve JJ has flow rate=21; tunnel leads to valve II", nameToValve)
	expect(t, "JJ", valveJJ, 21, 1)
}

func expect(t *testing.T, name string, valve *puzzle.Valve, rate int, nTunnels int) {
	stored := nameToValve[name]
	if stored.Name != name {
		t.Fatalf("Expected valve name %s, but got %s", name, valve.Name)
	}
	if stored != valve {
		t.Fatalf("Valve %s not found in map", name)
	}
	if stored.Flow != rate {
		t.Fatalf("Valve %s expected rate %d, but got %d", name, rate, stored.Flow)
	}
	if len(stored.Tunnels) != nTunnels {
		t.Fatalf("Valve %s expected %d tunnels, but got %d", name, nTunnels, len(stored.Tunnels))
	}
}
