.PHONY: test

default: test

test:
	bats tests/

install:
	src/includeAllConfigs "${PWD}/aux_configs"
	
