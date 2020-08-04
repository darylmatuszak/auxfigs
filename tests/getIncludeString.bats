load test_helper

function main() {
	source src/getIncludeString
	getIncludeString "${@}"
}

@test "getIncludeString" {
	aux="$(get_writeable_non_existent_path)"
	run main "$VALID_TEMPLATE" "$aux" "$VALID_PLACEHOLDER"
	[[ "${status}" -eq 0 ]]
	[ "${lines[0]}" == "${VALID_TEMPLATE%$VALID_PLACEHOLDER}""$aux" ]
}
