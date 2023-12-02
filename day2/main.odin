package main

import "core:fmt"
import "core:strconv"
import "core:strings"

//             hand
//         vvvvvvvvvvvvv
// Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
//         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//                          round

Color :: [3]int

parse_game_id :: proc(s: string) -> (int, string) {
	game, _, rest := strings.partition(s, ":")
	_, _, game_id_str := strings.partition(game, " ")
	game_id, _ := strconv.parse_int(game_id_str)

	return game_id, rest
}

check_colors :: proc(c1, c2: Color) -> bool {
	if c1.r > c2.r do return false
	if c1.g > c2.g do return false
	if c1.b > c2.b do return false
	return true
}

color_max :: proc(c1, c2: Color) -> Color {
	return Color{max(c1.r, c2.r), max(c1.g, c2.g), max(c1.b, c2.b)}
}

parse_hand :: proc(s: string) -> (res: Color) {
	s := s
	for part in strings.split_iterator(&s, ",") {
		p := strings.trim(part, " ")
		number, _, color := strings.partition(p, " ")
		n, _ := strconv.parse_int(number)
		switch color {
		case "red":
			res.r += n
		case "green":
			res.g += n
		case "blue":
			res.b += n
		}
	}
	return res
}

main :: proc() {
	input: string = #load("input.txt")

	sum := 0
	c := Color{12, 13, 14}

	power: int

	game: for line in strings.split_lines_iterator(&input) {
		game_id, rest := parse_game_id(line)

		game_ok := true
		max_color: Color
		for hand in strings.split_iterator(&rest, ";") {
			c_hand := parse_hand(hand)

			// part 2
			max_color = color_max(max_color, c_hand)

			// part 1
			if game_ok {
				if !check_colors(c_hand, c) do game_ok = false
			}
		}

		// part 1
		if game_ok do sum += game_id

		// part 2
		power += max_color.r * max_color.g * max_color.b
	}

	fmt.println("part 1:", sum)
	fmt.println("part 2:", power)
}
