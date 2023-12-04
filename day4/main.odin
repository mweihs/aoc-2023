package main

import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"

Part :: enum {
	One,
	Two,
}

winning_table: [128]b8

fill_winning_table :: proc(s: string) {
	s := s
	slice.zero(winning_table[:])

	for num in strings.split_iterator(&s, " ") {
		n, _ := strconv.parse_int(num)
		winning_table[n] = true
	}
}

process_line :: proc(s: string, part: Part) -> int {
	_, _, rest := strings.partition(s, ": ")
	winning_table_str, _, have_str := strings.partition(rest, " | ")

	fill_winning_table(winning_table_str)

	result := 0

	for num in strings.split_iterator(&have_str, " ") {
		if len(num) == 0 do continue
		n, _ := strconv.parse_int(num)
		if winning_table[n] {
			switch part {
			case .One:
				result = result == 0 ? 1 : result * 2
			case .Two:
				result += 1
			}
		}
	}

	return result
}

part_one :: proc(s: string) -> int {
	s := s
	sum := 0

	for line in strings.split_lines_iterator(&s) {
		sum += process_line(line, .One)
	}

	return sum
}

part_two :: proc(s: string) -> int {
	s := s
	line_list: [256]int

	idx := 0
	for line in strings.split_lines_iterator(&s) {
		line_list[idx] += 1
		curr := line_list[idx]
		n := process_line(line, .Two)
		if n > 0 {
			for i in 0 ..< n {
				line_list[idx + i + 1] += curr
			}
		}
		idx += 1
	}

	sum := 0
	for i in line_list do sum += i

	return sum
}

main :: proc() {
	data: string = #load("input.txt")
	fmt.println(part_one(data))
	fmt.println(part_two(data))
}
