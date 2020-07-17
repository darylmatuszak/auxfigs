load test_helper


function main() {
	src/includeAllConfigs "${@}"
}


@test "includeAllConfigs w/o args" {
	run main
	[ "${status}" -eq 2 ]
}


@test "includeAllConfigs w/ non existent dir" {
	run main "$EMPTY_STRING"
	[ "${status}" -eq 3 ]
}


@test "includeAllConfigs w/ unreadable dir" {
	run main "$UNREADABLE_DIR"
	[ "${status}" -eq 3 ]
}


@test "includeAllConfigs w/ valid aux_confs" {
	ac="$(get_valid_aux_confs)"
	run main "$ac"
	[ "${status}" -eq 0 ]
	[ "$(head -1 "$ac/main.one")" == "existing line" ]
	[ "$(head -1 "$ac/main.two")" == "existing line" ]
	[ "$(tail -1 "$ac/main.one")" == "${VALID_TEMPLATE%$VALID_PLACEHOLDER}$ac/one.aux" ]
	[ "$(tail -1 "$ac/main.two")" = "${VALID_TEMPLATE%$VALID_PLACEHOLDER}$ac/two.aux" ]
}

@test "includeAllConfigs w/ semi-valid aux_confs" {
	ac="$(get_incomplete_aux_confs)"
	run main "$ac"
	[ "${status}" -eq 1 ]
	[ "${lines[0]}" = "one is missing template" ]
	[ "${lines[1]}" == "two is missing main" ]
}
