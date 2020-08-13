load test_helper

function main() {
    source src/getIncludeString
    getIncludeString "${@}"
}

@test "getIncludeString" {
    aux="$(get_writeable_non_existent_path)"
    valid_template="$(get_valid_template)"
    valid_placeholder="$(get_valid_placeholder)"
    run main "$valid_template" "$aux" "$valid_placeholder"
    [[ "${status}" -eq 0 ]]
    [ "${lines[0]}" == "${valid_template%$valid_placeholder}""$aux" ]
}
