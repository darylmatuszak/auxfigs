load test_helper


function main() {
    src/auxfigs "${@}"
}


@test "functional w/o args" {
    run main
    [ "${status}" -eq 2 ]
}


@test "functional w/ non existent dir" {
    run main "$(get_empty_string)"
    [ "${status}" -eq 3 ]
}


@test "functional w/ unreadable dir" {
    run main "$(get_unreadable_dir)"
    [ "${status}" -eq 3 ]
}


@test "functional w/ valid aux_confs" {
    ac="$(get_valid_aux_confs)"
    run main "$ac"
    [ "${status}" -eq 0 ] || echo "# ${status}" >&3
    [ "$(head -1 "$ac/main.one")" == "existing line" ]
    [ "$(head -1 "$ac/main.two")" == "existing line" ]
    valid_template="$(get_valid_template)"
    valid_placeholder="$(get_valid_placeholder)"
    [ "$(tail -1 "$ac/main.one")" == "${valid_template%$valid_placeholder}$ac/one.aux" ]
    [ "$(tail -1 "$ac/main.two")" = "${valid_template%$valid_placeholder}$ac/two.aux" ]
}

@test "functional w/ semi-valid aux_confs" {
    ac="$(get_incomplete_aux_confs)"
    run main "$ac"
    [ "${status}" -eq 1 ]
    [ "${lines[0]}" = "one is missing template" ]
    [ "${lines[1]}" == "two is missing main" ]
}

@test "functional w/ removal" {
  ac="$(get_valid_aux_confs)"
  run main "$ac"
  run main "$ac" "remove"
    [ "$(tail -1 "$ac/main.one")" == "existing line" ]
    [ "$(tail -1 "$ac/main.two")" = "existing line" ]
}
