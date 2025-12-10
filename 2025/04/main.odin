package aoc

import "core:fmt"
import "core:os"

SIZE :: 135

main :: proc() {
	fmt.println("\x1b[2J\x1b[H")
	data := os.read_entire_file_from_filename("input") or_else os.exit(1)
	input := string(data)
	lines := make([dynamic]string)
	defer delete(lines)
	line_start := 0
	for i in 0 ..< len(input) {
		if input[i] == '\n' {
			append(&lines, input[line_start:i])
			line_start = i + 1
		}
	}
	if line_start < len(input) {
		append(&lines, input[line_start:])
	}
	grid := make([][]u8, len(lines))
	defer delete(grid)
	for line, i in lines {
		grid[i] = transmute([]u8)line
	}
	part1 := count_papers(grid)
	fmt.println("part1:", part1) // 1441
	part2 := remove_papers(grid)
	fmt.println("part2:", part2) // 9050
}

remove_papers :: proc(grid: [][]u8) -> int {
	papersRemoved: int
	for {
		papers: int
		remove: [SIZE][SIZE]bool
		for row in 0 ..< SIZE {
			for col in 0 ..< SIZE {
				closePapers: int
				if grid[row][col] != '@' {
					continue
				}
				if row + 1 < SIZE && grid[row + 1][col] == '@' {
					closePapers += 1
				}
				if row - 1 >= 0 && grid[row - 1][col] == '@' {
					closePapers += 1
				}
				if col + 1 < SIZE && grid[row][col + 1] == '@' {
					closePapers += 1
				}
				if col - 1 >= 0 && grid[row][col - 1] == '@' {
					closePapers += 1
				}
				if row + 1 < SIZE && col + 1 < SIZE && grid[row + 1][col + 1] == '@' {
					closePapers += 1
				}
				if row - 1 >= 0 && col - 1 >= 0 && grid[row - 1][col - 1] == '@' {
					closePapers += 1
				}
				if row + 1 < SIZE && col - 1 >= 0 && grid[row + 1][col - 1] == '@' {
					closePapers += 1
				}
				if row - 1 >= 0 && col + 1 < SIZE && grid[row - 1][col + 1] == '@' {
					closePapers += 1
				}
				if closePapers < 4 {
					remove[row][col] = true
					papers += 1
				}
			}
		}
		removedSomething: bool
		for row in 0 ..< SIZE {
			for col in 0 ..< SIZE {
				if remove[row][col] {
					grid[row][col] = '.'
					removedSomething = true
					papersRemoved += 1
				}
			}
		}
		if !removedSomething {
			break
		}
	}
	return papersRemoved
}

count_papers :: proc(grid: [][]u8) -> int {
	rows := len(grid)
	cols := len(grid[0])
	papers: int
	for row in 0 ..< rows {
		for col in 0 ..< cols {
			closePapers: int
			if grid[row][col] != '@' {
				continue
			}
			if row + 1 < rows && grid[row + 1][col] == '@' {
				closePapers += 1
			}
			if row - 1 >= 0 && grid[row - 1][col] == '@' {
				closePapers += 1
			}
			if col + 1 < cols && grid[row][col + 1] == '@' {
				closePapers += 1
			}
			if col - 1 >= 0 && grid[row][col - 1] == '@' {
				closePapers += 1
			}
			if row + 1 < rows && col + 1 < cols && grid[row + 1][col + 1] == '@' {
				closePapers += 1
			}
			if row - 1 >= 0 && col - 1 >= 0 && grid[row - 1][col - 1] == '@' {
				closePapers += 1
			}
			if row + 1 < rows && col - 1 >= 0 && grid[row + 1][col - 1] == '@' {
				closePapers += 1
			}
			if row - 1 >= 0 && col + 1 < cols && grid[row - 1][col + 1] == '@' {
				closePapers += 1
			}
			if closePapers < 4 {
				papers += 1
			}
		}
	}
	return papers
}

