package aoc

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

NUMBER_OF_COLS :: 1000
NUMBER_OF_ROWS :: 4

main :: proc() {
	fmt.println("\x1b[2J\x1b[H")
	data := os.read_entire_file_from_filename("input") or_else os.exit(1)
	input := string(data)
	grid: [NUMBER_OF_COLS][NUMBER_OF_ROWS]int
	operator: [NUMBER_OF_COLS]string
	i: int
	for row in strings.split_lines_iterator(&input) {
		array := strings.split(row, " ")
		j: int
		for numberStr in array {
			if numberStr == "" {
				continue
			}
			if number, ok := strconv.parse_int(numberStr); ok {
				grid[j][i] = number
			} else {
				operator[j] = numberStr
			}
			j += 1
		}
		i += 1
	}
	part1: int
	for i in 0 ..< NUMBER_OF_COLS {
		numbers := grid[i][0]
		for j in 1 ..< NUMBER_OF_ROWS {
			switch operator[i] {
			case "+":
				numbers += grid[i][j]
			case "*":
				numbers *= grid[i][j]
			}
		}
		part1 += numbers
	}
	fmt.println("part1", part1) // 5346286649122
}

