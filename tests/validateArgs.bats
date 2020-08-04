load test_helper


function main() {
  source src/validateArgs
  validateArgs "${@}"
}


@test "validateArgs w/ not enough args" {
  run main
  [ "${status}" -eq 7 ]
  run main "$EMPTY_STRING"
  [ "${status}" -eq 7 ]
  run main "$EMPTY_STRING" "$EMPTY_STRING"
  [ "${status}" -eq 7 ]
  run main "$EMPTY_STRING" "$EMPTY_STRING" "$EMPTY_STRING"
  [ "${status}" -eq 7 ]
}

@test "validateArgs w/ invalid template" {
  run main "$VALID_PLACEHOLDER" "$INVALID_TEMPLATE" "$READABLE_FILE" "$(get_writeable_non_existent_path)"
  [ "${status}" -eq 3 ]
}


@test "validateArgs w/ invalid aux" {
  run main "$VALID_PLACEHOLDER" "$VALID_TEMPLATE" "$EMPTY_STRING" "$(get_writeable_non_existent_path)"
  [ "${status}" -eq 4 ]
  run main "$VALID_PLACEHOLDER" "$VALID_TEMPLATE" "$UNREADABLE_FILE" "$(get_writeable_non_existent_path)"
  [ "${status}" -eq 4 ]
}


@test "validateArgs w/ invalid main" {
  run main "$VALID_PLACEHOLDER" "$VALID_TEMPLATE" "$READABLE_FILE" "$EMPTY_STRING"
  [ "${status}" -eq 5 ]
  run main "$VALID_PLACEHOLDER" "$VALID_TEMPLATE" "$READABLE_FILE" "$UNREADABLE_FILE"
  [ "${status}" -eq 5 ]
}


@test "validateArgs w/ valid args" {
  run main "$VALID_PLACEHOLDER" "$VALID_TEMPLATE" "$READABLE_FILE" "$(get_writeable_non_existent_path)"
  [ "${status}" -eq 0 ]
  run main "$VALID_PLACEHOLDER" "$VALID_TEMPLATE" "$READABLE_FILE" "$(get_blank_writeable_file)"
  [ "${status}" -eq 0 ]
}
#
#@test "validateArgs w/ rel path" {
#  run main "$VALID_PLACEHOLDER" "$VALID_TEMPLATE" "$READABLE_FILE" "$(get_writeable_non_existent_path)"
#  [ "${status}" -eq 0 ]
#}
#
#@test "validateArgs w/ trailing /" {
#  run main "$VALID_PLACEHOLDER" "$VALID_TEMPLATE" "$READABLE_FILE" "$(get_writeable_non_existent_path)"
#  [ "${status}" -eq 0 ]
#}
