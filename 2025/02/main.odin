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
			id := fmt.tprint(i)
			left := id[:len(id) / 2]
			right := id[len(id) / 2:]
			if id[:len(id) / 2] == id[len(id) / 2:] {
				part1 += i
				part2 += i
			} else if len(id) > 2 {
				fragment: for sliceSize in 1 ..= len(id) / 2 {
					if len(id) % sliceSize != 0 do continue
					firstPart := id[:sliceSize]
					for slice in 2 ..= len(id) / sliceSize {
						thisPart := id[slice * sliceSize - sliceSize:slice * sliceSize]
						if firstPart != thisPart do continue fragment
					}
					part2 += strconv.parse_int(id) or_else os.exit(1)
				}
			}
		}
	}
	fmt.println("\x1b[2J\x1b[H")
	fmt.println("part1:", part1) // 23534117921
	fmt.println("part2:", part2) // 31755323497
}

