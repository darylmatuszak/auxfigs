function fail() {
    echo "# ERROR IN TEST SETUP: $1" >&3
    exit 1
}

export FIXTURES="${BATS_TMPDIR}/fixtures"
if ! [ -d "$FIXTURES" ]; then
    mkdir "$FIXTURES"
fi

if ! [ -w "$FIXTURES" ]; then
    fail "unable to make a writeable dir ${BATS_TMPDIR}/fixtures"
fi

get_valid_placeholder() {
    echo "aauuxx__ccoonnff"
}

get_valid_template() {
    echo "[include] path = $(get_valid_placeholder)"
}

get_invalid_template() {
    echo "source ~/config.conf aux_config"
}

get_regex_unfriendly_insert_string() {
    echo 'look[] at this. wacky? string{yeah}'
}

get_readable_file() {
    echo "$0"
}

get_empty_string() {
    echo ""
}

get_writeable_non_existent_path() {
    file="$FIXTURES/${RANDOM}$(date +%s)${RANDOM}"
    while [ -e "$file" ]; do
    	file="$FIXTURES/${RANDOM}$(date +%s)${RANDOM}"
    done
    echo "$file"
}

dir="$(get_writeable_non_existent_path)"
mkdir "$dir"
touch "$dir/file"
chmod 000 "$dir"
if ! [ -r "$dir" ] && [ -d "$dir" ]; then
    export UNREADABLE_DIR="$dir"
    export UNREADABLE_FILE="$dir/file"
else
    fail "can't use $dir as an unreadable dir"
fi

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

    echo "$(get_valid_template)" > "$aux_confs/one.template"
    echo "$(get_valid_template)" > "$aux_confs/two.template"

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
    chmod -R 777 $FIXTURES/*
    rm -rf $FIXTURES/*
    unset UNREADABLE_DIR
    unset UNREADABLE_FILE
}
