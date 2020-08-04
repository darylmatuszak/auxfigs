load test_helper


function main() {
	source src/appendLineToFile 
  appendLineToFile "${@}"
}


@test "appendLineToFile w/ existing file" {
	file="$(get_writeable_file_w_existing_line)"
	run main "$REGEX_UNFRIENDLY_INSERT_STRING" "$file" 
	[ "${status}" -eq 0 ]
	[ "$(tail -1 "$file")" == "$REGEX_UNFRIENDLY_INSERT_STRING" ]
	[ "$(head -1 "$file")" == "existing line" ]
}


@test "appendLineToFile w/o existing file" {
	file="$(get_writeable_non_existent_path)"
	run main "$REGEX_UNFRIENDLY_INSERT_STRING" "$file" 
	[ "${status}" -eq 0 ]
	[ "$(tail -1 "$file")" == "$REGEX_UNFRIENDLY_INSERT_STRING" ]
}


@test "appendLineToFile w/ existing file w/ existing entry" {
	file="$(get_writeable_file_w_existing_line)"
	echo "$REGEX_UNFRIENDLY_INSERT_STRING" >> "$file"
	run main "$REGEX_UNFRIENDLY_INSERT_STRING" "$file"
	[ "${status}" -eq 0 ]
	count="$(grep -c -F "$REGEX_UNFRIENDLY_INSERT_STRING" "$file")"
	[  "$count" -eq 1 ]
}
