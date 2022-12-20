
.PRECIOUS: bin/%.jar

bin/% : src/%.rb
	echo "#!/usr/bin/env ruby\nrequire_relative '../$<'\nmain" > $@
	chmod +x $@

bin/% : bin/%.jar
	echo "#!/bin/bash\njava -jar $<" > $@
	chmod +x $@

bin/%.jar : src/%.java
	script/pack_java.rb "$<" "$@"

clean:
	rm bin/*

.PHONY: clean