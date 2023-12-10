TARGET = main.rb
TEST_TARGETS = $(wildcard *_test.rb)

run:
	@if [ -z "$(wildcard *.txt)" ]; then \
		echo ":: No .txt files found in the directory"; \
	else \
		for file in *.txt; do \
			echo ":: Running on file: $$file"; \
			ruby $(TARGET) "$$file"; \
		done \
	fi

test:
	@if [ -z "$(TEST_TARGETS)" ]; then \
		echo "No *_test.rb files found in the directory"; \
	else \
		for test_file in $(TEST_TARGETS); do \
			echo "Running test: $$test_file"; \
			ruby $$test_file; \
		done \
	fi