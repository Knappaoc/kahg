package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
	"strings"
)

type Directory struct {
	parent  *Directory
	size    uint
	subdirs map[string]*Directory
}

type Accumulator struct {
	cwd  *Directory
	root *Directory
}

func check(err error) {
	if err != nil {
		log.Fatalf("Error: %v\n", err)
	}
}

func main() {
	file, err := os.Open("input")
	check(err)
	defer file.Close()

	root := Directory{subdirs: make(map[string]*Directory)}
	cwd := &root
	scanner := bufio.NewScanner(file)

	// Find the the first instruction
	scanner.Scan()

	// Parse the instructions
	for scanner.Scan() {
		line := scanner.Text()

		parts := strings.Split(line, " ")
		if parts[0] == "$" && parts[1] == "cd" {
			switch parts[2] {
			case "..":
				if cwd.parent != nil {
					cwd = cwd.parent
				}
			case "/":
				cwd = &root
			default:
				if cwd.subdirs[parts[2]] == nil {
					cwd.subdirs[parts[2]] = &Directory{
						parent:  cwd,
						subdirs: make(map[string]*Directory),
					}
				}
				cwd = cwd.subdirs[parts[2]]
			}
		} else {
			value, parse_err := strconv.Atoi(parts[0])
			if parse_err == nil {
				cwd.size += uint(value)
			}
		}
	}

	var sizes []uint = sizeStructure(&root)
	var totalSize = sizes[len(sizes)-1]

	required := totalSize - (70000000 - 30000000)

	var part1Total uint = 0
	var part2Size uint = 0

	for _, dirSize := range sizes {
		if dirSize < 100000 {
			part1Total = part1Total + dirSize
		}
		if dirSize >= required && (dirSize < part2Size || part2Size == 0) {
			part2Size = dirSize
		}
	}

	fmt.Printf("Part 1 total: %v\n", part1Total)
	fmt.Printf("Part 2 size:  %v\n", part2Size)
}

func sizeStructure(root *Directory) []uint {
	var total uint = root.size
	var sizes []uint = make([]uint, len(root.subdirs)+1)
	for _, info := range root.subdirs {
		subsizes := sizeStructure(info)
		sizes = append(sizes, subsizes...)
		total = total + subsizes[len(subsizes)-1]
	}
	return append(sizes, total)
}
