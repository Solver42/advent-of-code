package aoc

import "core:fmt"
import "core:os"
import "core:slice"
import "core:sort"
import "core:strconv"
import "core:strings"

main :: proc() {
	fmt.println("\x1b[2J\x1b[H")
	data := os.read_entire_file_from_filename("input") or_else os.exit(1)
	it := string(data)
	left, right: [1000]int
	i: int
	for line in strings.split_lines_iterator(&it) {
		head, _, tail := strings.partition(line, "   ")
		left[i] = strconv.parse_int(head) or_else os.exit(1)
		right[i] = strconv.parse_int(tail) or_else os.exit(1)
		i += 1
	}
	slice.sort(left[:])
	slice.sort(right[:])
	sum1: int
	for i in 0 ..= len(left) - 1 {
		sum1 += abs(left[i] - right[i])
	}
	fmt.println("part1:", sum1) //	1530215
	sum2: int
	for i in left {
		nrOfiInj: int
		for j in right {
			if i == j {
				nrOfiInj += 1
			}
		}
		sum2 += i * nrOfiInj
	}
	fmt.println("part2:", sum2) //	26800609
}

