package puzzle

import (
	"sort"
)

type Valve struct {
	Name    string
	Flow    int
	Tunnels []*Valve
	Routes  []Route
}

type Route struct {
	Distance int
	Valve    *Valve
}

func NewValve(name string) *Valve {
	valve := Valve{
		Name:    name,
		Flow:    0,
		Tunnels: make([]*Valve, 0),
		Routes:  make([]Route, 0),
	}
	return &valve
}

func (from *Valve) FindRoutes(stops []*Valve) {
	unseen := make(map[*Valve]bool)
	for _, v := range stops {
		if v != from {
			unseen[v] = true
		}
	}

	dist := map[*Valve]int{from: 0}
	queue := []*Valve{from}
	toRemove := []*Valve{from}

	for len(unseen) > 0 && len(queue) > 0 {
		valve := queue[0]
		if len(queue) > 1 {
			queue = queue[1:]
		} else {
			queue = make([]*Valve, 0)
		}

		valveDist := dist[valve]

		// If it is in the map, them we have already seen it
		for _, neighbour := range valve.Tunnels {
			_, existing := dist[neighbour]
			if !existing {
				dist[neighbour] = valveDist + 1
				queue = append(queue, neighbour)

				_, isInteresting := unseen[neighbour]
				if isInteresting {
					delete(unseen, neighbour)
				} else {
					toRemove = append(toRemove, neighbour)
				}
			}
		}
	}

	for _, v := range stops {
		if v != from {
			from.Routes = append(from.Routes, Route{Valve: v, Distance: dist[v]})
		}
	}

	sort.Slice(from.Routes, func(i, j int) bool {
		if from.Routes[i].Distance != from.Routes[j].Distance {
			return from.Routes[i].Distance < from.Routes[j].Distance
		}
		return from.Routes[i].Valve.Flow > from.Routes[j].Valve.Flow
	})
}
