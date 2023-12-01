package main

import "core:fmt"
import "core:strings"
import "core:time"


num :: struct {
	s: string,
	v: int,
}

numbers: [256][]num = {
	'o' = {{"one", 1}},
	't' = {{"two", 2}, {"three", 3}},
	'f' = {{"four", 4}, {"five", 5}},
	's' = {{"six", 6}, {"seven", 7}},
	'e' = {{"eight", 8}},
	'n' = {{"nine", 9}},
}


parse :: proc(s: string, part_two: bool) -> int {
	first, last: int

	for i := 0; i < len(s); i += 1 {
		// part one
		c := (int)(s[i] - '0')
		if 1 <= c && c <= 9 {
			if first == 0 do first = c
			last = c
			continue
		}

		// part two
		if part_two {
			for n in numbers[s[i]] {
				if len(s[i:]) < len(n.s) do continue

				if s[i:i + len(n.s)] == n.s {
					if first == 0 do first = n.v
					last = n.v
					i += len(n.s) - 2
				}
			}
		}
	}

	return first * 10 + last
}

main :: proc() {
	data: string = #load("input.txt")
	sum_one, sum_two: int

	sw: time.Stopwatch

	time.stopwatch_start(&sw)
	for line in strings.split_lines_iterator(&data) {
		sum_one += parse(line, false)
		sum_two += parse(line, true)
	}
	time.stopwatch_stop(&sw)

	fmt.println(time.stopwatch_duration(sw))

	fmt.printf("one: %d\ntwo: %d\n", sum_one, sum_two)
}
