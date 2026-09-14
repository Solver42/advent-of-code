package main

import "core:os"
import "core:strings"
import "core:strconv"
import "core:fmt"

rules : [dynamic]Rule

Rule :: struct {
	before: int,
	after:  [dynamic]int,
}

main :: proc() {
	data      := os.read_entire_file_from_path("input", context.allocator) or_else os.exit(1)
	my_string := string(data)
	page_ordering_rules, _, page_numbers := strings.partition(my_string, "\n\n")
	rule_array  := strings.split(page_ordering_rules, "\n")
	update_array   := strings.split(page_numbers, "\n")
	for rule_string, i in rule_array {
		k_string, _, v_string := strings.partition(rule_string, "|")
		k := strconv.parse_int(k_string) or_else os.exit(1)
		v := strconv.parse_int(v_string) or_else os.exit(1)
		contains_key := false
		append_loop: for &rule in rules {
			if rule.before == k {
				append(&rule.after, v)
				contains_key = true
				break append_loop
			}
		}
		if !contains_key {
			dynArr := make([dynamic]int)
			append(&dynArr, v)
			oneToMany :Rule= {before = k, after = dynArr}
			append(&rules, oneToMany)
		}
	}
	correct_updates : [dynamic][dynamic]int
	incorrect_updates : [dynamic][dynamic]int
	update_loop: for row, i in update_array[:len(update_array) - 1 ] {
		list := strings.split(row, ",")
		update := make([dynamic]int)
		for page in list {
			append(&update, strconv.parse_int(page) or_else os.exit(1))
		}
		for page, i in update {
			if i == 0 { continue }
			for j in rules {
				if j.before == page {
					for v in j.after {
						if update[i -1 ] == v {
							fmt.print("\n * wrong k:", page)
							fmt.println("\n * wront v:", v)
							append(&incorrect_updates, update)
							continue update_loop
						}
					}
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
	sorted_updates := sort_updates(incorrect_updates)
	part2 : int
	for row, i in sorted_updates {
		part2 += row[len(row)/2]
	}
	fmt.println("part2:", part2)
	// 5169
}

sort_updates :: proc(incorrect_updates: [dynamic][dynamic]int) -> [dynamic][dynamic]int {
	sorted_updates := make([dynamic][dynamic]int)
	for update in incorrect_updates {
		sorted := kahns_algorithm(update[:])
		append(&sorted_updates, sorted)
	}
	return sorted_updates
}

kahns_algorithm :: proc(update: []int) -> [dynamic]int{
	graph := make(map[int][dynamic]int)
	in_degree := make(map[int]int)
	defer {
		for _, neighbors in graph {
			delete (neighbors)
		}
		delete (graph)
		delete (in_degree)
	}
	for item in update {
		in_degree[item] = 0
	}
	for rule in rules {
		if rule.before not_in in_degree do continue
			for after_item in rule.after {
				if after_item not_in in_degree do continue
					if rule.before not_in graph {
						graph[rule.before] = make([dynamic]int)
					}
					arr := graph[rule.before]
					append(&arr, after_item)
					graph[rule.before] = arr
					in_degree[after_item] += 1
			}
	}

	queue := make([dynamic]int)
	defer delete(queue)

	for item, degree in in_degree {
		if degree == 0 {
			append(&queue, item)
		}
	}

	sorted_update := make([dynamic]int)
	head := 0

	for head < len(queue) {
		current := queue[head]
		head += 1
		append(&sorted_update, current)
		if current in graph {
			for neighbor in graph[current] {
				in_degree[neighbor] -= 1
				if in_degree[neighbor] == 0 {
					append(&queue, neighbor)
				}
			}
		}
	}

	return sorted_update
}
