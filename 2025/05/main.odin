package aoc

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

NUMBER_OF_RANGES :: 182
NUMBER_OF_IDS :: 1000

Range :: struct {
	fr: int,
	to: int,
}

main :: proc() {
	fmt.println("\x1b[2J\x1b[H")
	fmt.println("processing...")
	data := os.read_entire_file_from_filename("input") or_else os.exit(1)
	input := string(data)
	rangesStr, _, idsStr := strings.partition(input, "\n\n")
	ranges: [dynamic]Range
	defer delete(ranges)
	for rangeStr in strings.split_lines_iterator(&rangesStr) {
		head, _, tail := strings.partition(rangeStr, "-")
		fr := strconv.parse_int(head) or_else os.exit(1)
		to := strconv.parse_int(tail) or_else os.exit(1)
		for &range in ranges {
			if (fr >= range.fr && fr <= range.to) || (to >= range.fr && to <= range.to) {
				range = Range{min(fr, range.fr), max(to, range.to)}
				break
			}
		}
		append(&ranges, Range{fr, to})
		for {
			somethingUpdated: bool
			for &range in ranges {
				for &otherRange in ranges {
					if range == otherRange {
						continue
					}
					if (otherRange.fr >= range.fr && otherRange.fr <= range.to) ||
					   (otherRange.to >= range.fr && otherRange.to <= range.to) {
						range = Range{min(otherRange.fr, range.fr), max(otherRange.to, range.to)}
						otherRange = range
						somethingUpdated = true
						break
					}
				}
				for i := len(ranges) - 1; i >= 0; i -= 1 {
					for j in 0 ..< i {
						if ranges[i].fr == ranges[j].fr && ranges[i].to == ranges[j].to {
							unordered_remove(&ranges, i)
							somethingUpdated = true
							break
						}
					}
				}
			}
			if !somethingUpdated {
				break
			}
		}
	}
	part1: int
	ids: [NUMBER_OF_IDS]int
	i: int
	for idStr in strings.split_lines_iterator(&idsStr) {
		ids[i] = strconv.parse_int(idStr) or_else os.exit(1)
		i += 1
	}
	for id in ids {
		for range in ranges {
			if id >= range.fr && id <= range.to {
				part1 += 1
				break
			}
		}
	}
	fmt.println("part1:", part1) // 601
	uniqueFreshIds: int
	for range in ranges {
		uniqueFreshIds += range.to - range.fr + 1
	}
	fmt.println("part2:", uniqueFreshIds) // 367899984917516
}

