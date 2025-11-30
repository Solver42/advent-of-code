package aoc

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

main :: proc() {
	fmt.println("\x1b[2J\x1b[H")
	data := os.read_entire_file_from_filename("input") or_else os.exit(1)
	it := string(data)
	part1: int
	part2: int
	for line in strings.split_lines_iterator(&it) {
		split := strings.split(line, " ") or_else os.exit(1)
		defer delete(split)
		levels: [dynamic]int
		defer delete(levels)
		for i in 0 ..< len(split) {
			append(&levels, strconv.parse_int(split[i]) or_else os.exit(1))
		}
		if is_report_safe(levels[:]) {
			part1 += 1
			part2 += 1
		} else {
			if is_report_safe_with_problem_dampener(levels[:]) {
				part2 += 1
			}
		}
	}
	fmt.println("part1: ", part1)
	fmt.println("part2: ", part2)
}

is_report_safe_with_problem_dampener :: proc(levels: []int) -> bool {
	number_of_levels := len(levels)
	for i := 0; i < number_of_levels; i += 1 {
		dampened_levels: [dynamic]int
		defer delete(dampened_levels)
		for j in 0 ..< number_of_levels {
			if j != i {
				append(&dampened_levels, levels[j])
			}
		}
		if is_report_safe(dampened_levels[:]) {
			return true
		}
	}
	return false
}

is_report_safe :: proc(levels: []int) -> bool {
	levelAscending := true
	for level, i in levels {
		if i == 0 {continue}
		if level == levels[i - 1] {
			return false
		}
		diff := levels[i] - levels[i - 1]
		if diff < 0 || diff > 3 {
			levelAscending = false
			break
		}
	}
	if levelAscending {
		return true
	}
	return is_reverse_level_safe(levels)
}

is_reverse_level_safe :: proc(levels: []int) -> bool {
	for level, i in levels {
		if i == 0 {continue}
		if level == levels[i - 1] {
			return false
		}
		diff := levels[i - 1] - levels[i]
		if diff < 0 || diff > 3 {
			return false
		}
	}
	return true
}

