package puzzle

import (
	"strings"
)

type Scoring struct {
	Path  []*Valve
	Score int
}

// Map of paths to their scores
type Scores map[string]int

func (s Scores) AddScore(path []*Valve, score int) {
	name := pathKey(path)
	value, existing := s[name]
	if existing {
		if score < value {
			// The new score is less than value
			return
		}
	}
	s[name] = score
}

func pathKey(path []*Valve) string {
	names := make([]string, len(path))
	for i, p := range path {
		names[i] = p.Name
	}
	return strings.Join(names, ",")
}
