.PHONY: check test docs-check

check: docs-check test

docs-check:
	scripts/check-docs.sh

test:
	tests/check-docs-test.sh
