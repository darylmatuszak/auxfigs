.PHONY: test

default: test

test:
	src/run_tests

install:
	src/auxfigs "${PWD}/aux_configs"

remove:
	src/auxfigs "${PWD}/aux_configs" remove
