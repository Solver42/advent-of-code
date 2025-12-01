package aoc

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

ROWS: int : 4498

main :: proc() {
	fmt.println("\x1b[2J\x1b[H")
	data := os.read_entire_file_from_filename("input") or_else os.exit(1)
	input := string(data)
	rotations: [ROWS]int
	directions: [ROWS]bool
	dial := 50
	part1: int
	part2: int
	i: int
	for line in strings.split_lines_iterator(&input) {
		rotations[i] = strconv.parse_int(line[1:]) or_else os.exit(1)
		directions[i] = line[:1] == "R"
		i += 1
	}
	for i in 0 ..< ROWS {
		if directions[i] {
			for j in 0 ..< rotations[i] {
				dial += 1
				if dial == 100 {
					dial = 0
				}
				if dial == 0 {
					part2 += 1
				}
			}
		} else {
			for j in 0 ..< rotations[i] {
				dial -= 1
				if dial == 0 {
					part2 += 1
				}
				if dial == -1 {
					dial = 99
				}
			}
		}
		if dial == 0 {
			part1 += 1
		}
	}
	fmt.println("part1: ", part1) // 1129
	fmt.println("part2: ", part2) // 6638
}

