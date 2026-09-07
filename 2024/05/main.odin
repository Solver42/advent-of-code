package main

import "core:os"
import "core:strings"
import "core:strconv"
import "core:fmt"

NUMBER_OF_RULES :: 1176

main :: proc() {
	data      := os.read_entire_file_from_path("input", context.allocator) or_else os.exit(1)
	my_string := string(data)
	page_ordering_rules, _, page_numbers := strings.partition(my_string, "\n\n")
	rows   := strings.split(page_numbers, "\n")
	rules  := strings.split(page_ordering_rules, "\n")
	before : [NUMBER_OF_RULES]int
	after  : [NUMBER_OF_RULES]int

	for rule, i in rules {
		list := strings.split(rule, "|")
		before[i] = strconv.parse_int(list[0]) or_else os.exit(1)
		after[i]  = strconv.parse_int(list[1]) or_else os.exit(1)
	}

	rule := strings.split(page_ordering_rules, "|")
	
	correct_updates : [dynamic][dynamic]int

	update_loop: for row, i in rows[:len(rows) - 1 ] {
		list := strings.split(row, ",")
		update := make([dynamic]int)
		for page in list {
			append(&update, strconv.parse_int(page) or_else os.exit(1))
		}

		for page, i in update {
			if i == 0 { continue }
			for j in 0..< NUMBER_OF_RULES {
				if page == before[j] && update[i -1 ] == after[j]{
					continue update_loop
				}
			}
		}

		append(&correct_updates, update)
	}
	part1 : int
	for row, i in correct_updates {
		part1 += row[len(row)/2]
	}
	fmt.println("part1:", part1)
	// 6242
}
