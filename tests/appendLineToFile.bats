load test_helper


function main() {
    source src/appendLineToFile 
  appendLineToFile "${@}"
}


@test "appendLineToFile w/ existing file" {
    file="$(get_writeable_file_w_existing_line)"
    run main "$(get_regex_unfriendly_insert_string)" "$file" 
    [ "${status}" -eq 0 ]
    [ "$(tail -1 "$file")" == "$(get_regex_unfriendly_insert_string)" ]
    [ "$(head -1 "$file")" == "existing line" ]
}


@test "appendLineToFile w/o existing file" {
    file="$(get_writeable_non_existent_path)"
    run main "$(get_regex_unfriendly_insert_string)" "$file" 
    [ "${status}" -eq 0 ]
    [ "$(tail -1 "$file")" == "$(get_regex_unfriendly_insert_string)" ]
}


@test "appendLineToFile w/ existing file w/ existing entry" {
    file="$(get_writeable_file_w_existing_line)"
    echo "$(get_regex_unfriendly_insert_string)" >> "$file"
    run main "$(get_regex_unfriendly_insert_string)" "$file"
    [ "${status}" -eq 0 ]
    count="$(grep -c -F "$(get_regex_unfriendly_insert_string)" "$file")"
    [  "$count" -eq 1 ]
}
