package aoc

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

main :: proc() {
	fmt.println("\x1b[2J\x1b[H")
	fmt.println("processing...")
	part1: int
	part2: int
	input := os.read_entire_file_from_filename("input") or_else os.exit(1)
	ranges := strings.split(transmute(string)input, ",")
	for range in ranges {
		head, _, tail := strings.partition(range, "-")
		tail = strings.trim(tail, "\n")
		from := strconv.parse_int(head) or_else os.exit(1)
		to := strconv.parse_int(tail) or_else os.exit(1)
		for i in from ..= to {
			s := fmt.tprint(i)
			left := s[:len(s) / 2]
			right := s[len(s) / 2:]
			if s[:len(s) / 2] == s[len(s) / 2:] {
				part1 += i
			}
		}
	}
	fmt.println("\x1b[2J\x1b[H")
	fmt.println("part1:", part1) // 23534117921
}

