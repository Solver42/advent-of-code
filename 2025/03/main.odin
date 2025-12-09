package aoc

import "core:bytes"
import "core:fmt"
import "core:os"
import "core:slice"
import "core:strconv"
import "core:strings"

BANKS :: 200
BATTERIES_PART1 :: 2
BATTERIES_PART2 :: 12
BATTERIES_PER_BANK :: 100
TOTAL_NUMBER_OF_BATTERIES :: BANKS * BATTERIES_PER_BANK

main :: proc() {
	fmt.println("\x1b[2J\x1b[H")
	data := os.read_entire_file_from_filename("input") or_else os.exit(1)
	batteries: [TOTAL_NUMBER_OF_BATTERIES]int
	batteryIndex: int
	for b in data {
		if '1' <= b && b <= '9' {
			batteries[batteryIndex] = int(b - '0')
			batteryIndex += 1
		}
	}
	part1 := highestJoltage(batteries[:BATTERIES_PER_BANK], BATTERIES_PART1)
	part2 := highestJoltage(batteries[:BATTERIES_PER_BANK], BATTERIES_PART2)
	for batteryIndex in 1 ..< BANKS {
		part1 += highestJoltage(
			batteries[batteryIndex *
			BATTERIES_PER_BANK:batteryIndex * (BATTERIES_PER_BANK) +
			BATTERIES_PER_BANK],
			BATTERIES_PART1,
		)
	}
	for batteryIndex in 1 ..< BANKS {
		part2 += highestJoltage(
			batteries[batteryIndex *
			BATTERIES_PER_BANK:batteryIndex * (BATTERIES_PER_BANK) +
			BATTERIES_PER_BANK],
			BATTERIES_PART2,
		)
	}
	fmt.println("part1:", part1) // 17330
	fmt.println("part2:", part2) // 171518260283767
}

highestJoltage :: proc(bank: []int, number_of_batteries: int) -> int {
	batteries: [BATTERIES_PER_BANK]bool
	maxRange := BATTERIES_PER_BANK - number_of_batteries
	for i := number_of_batteries; i >= 1; i -= 1 {
		startIndex := BATTERIES_PER_BANK - i
		leftestIndexWithHighestNumber := startIndex
		for j := startIndex; j >= startIndex - maxRange; j -= 1 {
			if batteries[j] {
				break
			}
			if bank[j] >= bank[leftestIndexWithHighestNumber] {
				leftestIndexWithHighestNumber = j
			}
		}
		batteries[leftestIndexWithHighestNumber] = true
	}
	highest: int
	multiplyer := number_of_batteries - 1
	for i in 0 ..< BATTERIES_PER_BANK {
		if !batteries[i] {
			continue
		}
		joltage := bank[i]
		for j in 0 ..< multiplyer {
			joltage *= 10
		}
		multiplyer -= 1
		highest += joltage
	}
	return highest
}

