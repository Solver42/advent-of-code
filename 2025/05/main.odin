package aoc

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

NUMBER_OF_RANGES :: 182

main :: proc() {
	fmt.println("\x1b[2J\x1b[H")
	data := os.read_entire_file_from_filename("input") or_else os.exit(1)
	input := string(data)
	rangesStr, _, idsStr := strings.partition(input, "\n\n")
	ranges: [NUMBER_OF_RANGES][2]int
	i: int
	for range in strings.split_lines_iterator(&rangesStr) {
		fr, _, to := strings.partition(range, "-")
		ranges[i][0] = strconv.parse_int(fr) or_else os.exit(1)
		ranges[i][1] = strconv.parse_int(to) or_else os.exit(1)
		i += 1
	}
	part1: int
	for idStr in strings.split_lines_iterator(&idsStr) {
		id := strconv.parse_int(idStr) or_else os.exit(1)
		for i in 0 ..< NUMBER_OF_RANGES {
			if id >= ranges[i][0] && id <= ranges[i][1] {
				part1 += 1
				break
			}
		}
	}
	fmt.println("part1:", part1) // 601
}

