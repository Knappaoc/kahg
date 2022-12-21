package puzzle

type Option struct {
	Path  []*Valve
	Score int
}

func NewOption(path []*Valve, score int) Option {
	option := Option{
		Path:  make([]*Valve, len(path)),
		Score: score,
	}
	copy(option.Path, path)
	return option
}

func AreDisjoint(left, right Option) bool {
	return uncommon(left.Path, right.Path) && uncommon(right.Path, left.Path)
}

func uncommon(left, right []*Valve) bool {
	seen := make(map[string]bool)
	for i, v := range left {
		if i > 0 {
			seen[v.Name] = true
		}
	}

	for i, v := range right {
		if i > 0 {
			if seen[v.Name] {
				return false
			}
		}
	}
	return true
}
