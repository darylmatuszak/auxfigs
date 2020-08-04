load test_helper

function main() {
	source src/removeLineFromFile
	removeLineFromFile "${@}"
}

@test "removeLineFromFile w/ non-existent file" {
	non_existent_file="$(get_writeable_non_existent_path)"
  run main "$REGEX_UNFRIENDLY_INSERT_STRING" "$non_existent_file"
	[ "${status}" -eq 0 ]
	[ "${lines[0]}" == "$non_existent_file does not exist" ]
}

@test "removeLineFromFile w/ file not containing line" {
  file="$(get_writeable_file_w_existing_line)"
  run main "$REGEX_UNFRIENDLY_INSERT_STRING" "$file"
	[ "${status}" -eq 0 ]
	[ "${lines[0]}" == "$file does not contain $REGEX_UNFRIENDLY_INSERT_STRING" ]
}

@test "removeLineFromFile w/ file containing line" {
  file="$(get_writeable_file_w_existing_line)"
  file_cksum_target="$(cksum "$file")"
  echo "$REGEX_UNFRIENDLY_INSERT_STRING" >> "$file"
  echo "$REGEX_UNFRIENDLY_INSERT_STRING" >> "$file"
  run main "$REGEX_UNFRIENDLY_INSERT_STRING" "$file"
	[ "${status}" -eq 0 ]
  file_cksum="$(cksum $file)"
  [ "$file_cksum_target" == "$(cksum "$file")" ]
}
