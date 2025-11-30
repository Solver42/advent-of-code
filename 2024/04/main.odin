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
	result := count_xmas(grid)
	// 	result := count_xmas_inline(grid)
	fmt.println("Found XMAS:", result, "times")
}

check_xmas :: proc(grid: [][]u8, row, col, deltaRow, deltaCol: int) -> bool {
	rows := len(grid)
	cols := len(grid[0])
	target := "XMAS"
	for i in 0 ..< len(target) {
		r := row + i * deltaRow
		c := col + i * deltaCol
		// Out of bounds check
		if r < 0 || r >= rows || c < 0 || c >= cols {
			return false
		}
		// Character mismatch
		if grid[r][c] != target[i] {
			return false
		}
	}
	return true
}

count_xmas :: proc(grid: [][]u8) -> int {
	rows := len(grid)
	cols := len(grid[0])
	count := 0
	directions := [][2]int {
		{0, 1}, // right
		{0, -1}, // left
		{1, 0}, // down
		{-1, 0}, // up
		{1, 1}, // down-right
		{1, -1}, // down-left
		{-1, 1}, // up-right
		{-1, -1}, // up-left
	}
	for row in 0 ..< rows {
		for col in 0 ..< cols {
			// Only check if current cell is 'X'
			if grid[row][col] == 'X' {
				for dir in directions {
					if check_xmas(grid, row, col, dir.x, dir.y) {
						count += 1
					}
				}
			}
		}
	}
	return count
}

count_xmas_inline :: proc(grid: [][]u8) -> int {
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
			// repeat for other 6 directions
		}
	}
	return count
}

