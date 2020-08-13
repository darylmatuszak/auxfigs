function fail() {
    echo "# ERROR IN TEST SETUP: $1" >&3 exit 1
}

export FIXTURES="${BATS_TMPDIR}/fixtures"
if ! [ -d "$FIXTURES" ]; then
    mkdir "$FIXTURES"
fi

if ! [ -w "$FIXTURES" ]; then
    fail "unable to make a writeable dir ${BATS_TMPDIR}/fixtures"
fi

dir="/root"
if ! [ -r "$dir" ] && [ -d "$dir" ]; then
    export UNREADABLE_DIR="$dir"
    export UNREADABLE_FILE="$dir"/file
else
    fail "can't use root as an unreadable dir"
fi

export VALID_PLACEHOLDER="aauuxx__ccoonnff"
export VALID_TEMPLATE="[include] path = $VALID_PLACEHOLDER"
export INVALID_TEMPLATE="source ~/config.conf aux_config"
export REGEX_UNFRIENDLY_INSERT_STRING="look[] at this. wacky? string{yeah}"
export READABLE_FILE="$0"
export EMPTY_STRING=""

get_writeable_non_existent_path() {
    file="$FIXTURES/${RANDOM}$(date +%s)${RANDOM}"
    while [ -e "$file" ]; do
    	file="$FIXTURES/${RANDOM}$(date +%s)${RANDOM}"
    done
    echo "$file"
}

get_blank_writeable_file() {
    file="$(get_writeable_non_existent_path)"
    touch "$file"
    echo "$file"
}

get_writeable_file_w_existing_line() {
    file="$(get_writeable_non_existent_path)"
    echo "existing line" > "$file"
    echo "$file"
}


get_valid_aux_confs() {
    aux_confs="$(get_writeable_non_existent_path)"
    mkdir "$aux_confs"

    touch "$aux_confs/one.aux"
    touch "$aux_confs/two.aux"

    echo "$VALID_TEMPLATE" > "$aux_confs/one.template"
    echo "$VALID_TEMPLATE" > "$aux_confs/two.template"

    echo "$aux_confs/main.one" > "$aux_confs/one.main"
    echo "$aux_confs/main.two" > "$aux_confs/two.main"

    echo "existing line" > "$aux_confs/main.one"
    echo "existing line" > "$aux_confs/main.two"
    echo "$aux_confs"
}

get_incomplete_aux_confs() {
    aux_confs="$(get_valid_aux_confs)"
    rm "$aux_confs"/one.template
    rm "$aux_confs"/two.main
    echo "$aux_confs"
}

teardown() {
    rm -rf "$FIXTURES"
    unset UNREADABLE_DIR
    unset UNREADABL_FILE
    unset VALID_PLACEHOLDER
    unset VALID_TEMPLATE
    unset REGEX_UNFRIENDLY_INSERT_STRING
    unset READABLE_FILE
    unset EMPTY_STRING
}
