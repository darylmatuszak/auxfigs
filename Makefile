.PHONY: test

default: test

test:
	bats tests/

install:
	src/auxfigs "${PWD}/aux_configs"

remove:
	src/auxfigs "${PWD}/aux_configs" remove
