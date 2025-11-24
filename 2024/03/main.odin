package aoc

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"
import "core:text/regex"

main :: proc() {
	fmt.println("\x1b[2J\x1b[H")
	data := os.read_entire_file_from_filename("input") or_else os.exit(1)
	input := string(data)
	part1: int
	part2: int
	enabled := true
	match_iterater :=
		regex.create_iterator(input, "mul\\(\\d+,\\d+\\)", flags = {}) or_else os.exit(1)

	dos_donts_iterator :=
		regex.create_iterator(input, "do\\(\\)|don\\'t\\(\\)", flags = {}) or_else os.exit(1)
	dos_donts_matches: [dynamic]regex.Capture
	defer delete(dos_donts_matches)

	for capture_do_dont in regex.match_iterator(&dos_donts_iterator) {
		cloned_capture: regex.Capture
		cloned_capture.pos = make([][2]int, len(capture_do_dont.pos))
		copy(cloned_capture.pos, capture_do_dont.pos)
		cloned_capture.groups = make([]string, len(capture_do_dont.groups))
		copy(cloned_capture.groups, capture_do_dont.groups)
		append(&dos_donts_matches, cloned_capture)
	}

	for capture in regex.match_iterator(&match_iterater) {
		for i in 0 ..= capture.pos[0][0] {
			if i == capture.pos[0][0] {
				num: [dynamic]int
				defer delete(num)
				match_iterater_int :=
					regex.create_iterator(capture.groups[0], "\\d+", flags = {}) or_else os.exit(1)
				for capture_int in regex.match_iterator(&match_iterater_int) {
					for i in capture_int.groups {
						j := strconv.parse_int(i) or_else os.exit(1)
						append(&num, j)
					}
				}
				part1 += num[0] * num[1]
				for k in 0 ..= i {
					for capture_dos_donts in dos_donts_matches {
						if k == capture_dos_donts.pos[0][0] {
							enabled = capture_dos_donts.groups[0] == "do()"
						}
					}
				}

				if enabled {
					part2 += num[0] * num[1]
				}
			}
		}
	}
	fmt.println("part1: ", part1)
	fmt.println("part2: ", part2)
}

