package aoc

import "core:bytes"
import "core:fmt"
import "core:os"
import "core:slice"
import "core:strconv"
import "core:strings"

BANKS :: 200
BATTERIES :: 2
BATTERIES_PER_BANK :: 100
NUMBER_OF_BATTERIES :: BANKS * BATTERIES_PER_BANK

main :: proc() {
	fmt.println("\x1b[2J\x1b[H")
	data := os.read_entire_file_from_filename("input") or_else os.exit(1)
	batteries: [NUMBER_OF_BATTERIES]int
	i: int
	for b in data {
		if '1' <= b && b <= '9' {
			batteries[i] = int(b - '0')
			i += 1
		}
	}
	part1 := highestvoltage(batteries[:BATTERIES_PER_BANK])
	for i in 1 ..< BANKS {
		part1 += highestvoltage(
			batteries[i * BATTERIES_PER_BANK:i * (BATTERIES_PER_BANK) + BATTERIES_PER_BANK],
		)
	}
	fmt.println("part1:", part1) // 17330
}

highestvoltage :: proc(bank: []int) -> int {
	highest := bank[BATTERIES_PER_BANK - 2] * 10 + bank[BATTERIES_PER_BANK - 1]
	for i in 1 ..= BATTERIES_PER_BANK {
		for j in 1 ..< i {
			voltage := bank[BATTERIES_PER_BANK - i] * 10 + bank[BATTERIES_PER_BANK - j]
			highest = max(highest, voltage)
		}
	}
	return highest
}

