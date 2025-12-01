package aoc

import "core:fmt"
import "core:os"

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
	part1 := count_xmas(grid)
	part2 := count_x_mas(grid)
	fmt.println("part1:", part1) // 2427
	fmt.println("part2:", part2) // 1900
}

count_xmas :: proc(grid: [][]u8) -> int {
	rows := len(grid)
	cols := len(grid[0])
	count := 0
	for row in 0 ..< rows {
		for col in 0 ..< cols {
			if grid[row][col] != 'X' do continue
			if col + 3 < cols &&
			   grid[row][col + 1] == 'M' &&
			   grid[row][col + 2] == 'A' &&
			   grid[row][col + 3] == 'S' {
				count += 1
			}
			if col - 3 >= 0 &&
			   grid[row][col - 1] == 'M' &&
			   grid[row][col - 2] == 'A' &&
			   grid[row][col - 3] == 'S' {
				count += 1
			}
			if row + 3 < cols &&
			   grid[row + 1][col] == 'M' &&
			   grid[row + 2][col] == 'A' &&
			   grid[row + 3][col] == 'S' {
				count += 1
			}
			if row - 3 >= 0 &&
			   grid[row - 1][col] == 'M' &&
			   grid[row - 2][col] == 'A' &&
			   grid[row - 3][col] == 'S' {
				count += 1
			}
			if row + 3 < rows &&
			   col + 3 < cols &&
			   grid[row + 1][col + 1] == 'M' &&
			   grid[row + 2][col + 2] == 'A' &&
			   grid[row + 3][col + 3] == 'S' {
				count += 1
			}
			if row - 3 >= 0 &&
			   col - 3 >= 0 &&
			   grid[row - 1][col - 1] == 'M' &&
			   grid[row - 2][col - 2] == 'A' &&
			   grid[row - 3][col - 3] == 'S' {
				count += 1
			}
			if row - 3 >= 0 &&
			   col + 3 < cols &&
			   grid[row - 1][col + 1] == 'M' &&
			   grid[row - 2][col + 2] == 'A' &&
			   grid[row - 3][col + 3] == 'S' {
				count += 1
			}
			if row + 3 < rows &&
			   col - 3 >= 0 &&
			   grid[row + 1][col - 1] == 'M' &&
			   grid[row + 2][col - 2] == 'A' &&
			   grid[row + 3][col - 3] == 'S' {
				count += 1
			}
		}
	}
	return count
}

count_x_mas :: proc(grid: [][]u8) -> int {
	rows := len(grid)
	cols := len(grid[0])
	count := 0
	for row in 1 ..< rows - 1 {
		for col in 1 ..< cols - 1 {
			if grid[row][col] != 'A' {
				continue
			}
			if ((grid[row - 1][col - 1] == 'M' && grid[row + 1][col + 1] == 'S') ||
				   (grid[row - 1][col - 1] == 'S' && grid[row + 1][col + 1] == 'M')) &&
			   ((grid[row - 1][col + 1] == 'M' && grid[row + 1][col - 1] == 'S') ||
					   (grid[row - 1][col + 1] == 'S' && grid[row + 1][col - 1] == 'M')) {
				count += 1
			}
		}
	}
	return count
}

