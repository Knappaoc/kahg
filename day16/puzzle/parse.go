package puzzle

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strings"
)

func ReadInput(fileName string) map[string]*Valve {
	file, err := os.Open(fileName)
	Check(err)
	defer file.Close()

	nameToValve := make(map[string]*Valve)

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := scanner.Text()
		if line != "" {
			Parse(scanner.Text(), nameToValve)
		}
	}

	return nameToValve
}

func Parse(line string, nameToValve map[string]*Valve) *Valve {
	var name string
	var flow int

	infoText, tunnelText, _ := strings.Cut(line, "tunnel leads to valve")
	if tunnelText == "" {
		infoText, tunnelText, _ = strings.Cut(line, "tunnels lead to valves")
	}
	n, err := fmt.Sscanf(infoText, "Valve %s has flow rate=%d;", &name, &flow)
	Check(err)
	if n != 2 {
		log.Fatalf("expected 3 things parsed, got %d\n", n)
	}

	var entry *Valve = createIfAbsent(nameToValve, name)
	entry.Flow = flow

	for _, t := range strings.Split(tunnelText, ",") {
		t = strings.TrimSpace(t)
		connect := createIfAbsent(nameToValve, t)
		entry.Tunnels = append(entry.Tunnels, connect)
	}

	return entry
}

func createIfAbsent(nameToValve map[string]*Valve, name string) *Valve {
	entry := nameToValve[name]
	if entry == nil {
		entry = NewValve(name)
		nameToValve[name] = entry
	}
	return entry
}
