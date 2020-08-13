load test_helper


function main() {
  source src/validateArgs
  validateArgs "${@}"
}


@test "validateArgs w/ not enough args" {
  run main
  [ "${status}" -eq 7 ]
  run main "$(get_empty_string)"
  [ "${status}" -eq 7 ]
  run main "$(get_empty_string)" "$(get_empty_string)"
  [ "${status}" -eq 7 ]
  run main "$(get_empty_string)" "$(get_empty_string)" "$(get_empty_string)"
  [ "${status}" -eq 7 ]
}

@test "validateArgs w/ invalid template" {
run main "$(get_valid_placeholder)" "$(get_invalid_template)" "$(get_readable_file)" "$(get_writeable_non_existent_path)" False
  [ "${status}" -eq 3 ]
}


@test "validateArgs w/ invalid aux" {
run main "$(get_valid_placeholder)" "$(get_valid_template)" "$(get_empty_string)" "$(get_writeable_non_existent_path)" False
  [ "${status}" -eq 4 ]
  run main "$(get_valid_placeholder)" "$(get_valid_template)" "$(get_unreadable_file)" "$(get_writeable_non_existent_path)" False
  [ "${status}" -eq 4 ]
}


@test "validateArgs w/ invalid main" {
run main "$(get_valid_placeholder)" "$(get_valid_template)" "$(get_readable_file)" "$(get_empty_string)" False
  [ "${status}" -eq 5 ]
  run main "$(get_valid_placeholder)" "$(get_valid_template)" "$(get_readable_file)" "$(get_unreadable_file)" False
  [ "${status}" -eq 5 ]
}


@test "validateArgs w/ valid args" {
run main "$(get_valid_placeholder)" "$(get_valid_template)" "$(get_readable_file)" "$(get_writeable_non_existent_path)" False
  [ "${status}" -eq 0 ]
  run main "$(get_valid_placeholder)" "$(get_valid_template)" "$(get_readable_file)" "$(get_blank_writeable_file)" False
  [ "${status}" -eq 0 ]
}
#
#@test "validateArgs w/ rel path" {
#  run main "$(get_valid_placeholder)" "$(get_valid_template)" "$(get_readable_file)" "$(get_writeable_non_existent_path)"
#  [ "${status}" -eq 0 ]
#}
#
#@test "validateArgs w/ trailing /" {
#  run main "$(get_valid_placeholder)" "$(get_valid_template)" "$(get_readable_file)" "$(get_writeable_non_existent_path)"
#  [ "${status}" -eq 0 ]
#}
