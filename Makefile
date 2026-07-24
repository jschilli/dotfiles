.PHONY: all darwin linux test

all:
	./install --profile auto

darwin:
	./install --profile darwin

linux:
	./install --profile linux

test:
	./tests/install-test.sh
