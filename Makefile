
.PRECIOUS: bin/%.jar

bin/% : src/%.rb
	echo "#!/usr/bin/env ruby\nrequire '$<'" > $@
	chmod +x $@

bin/% : bin/%.jar
	echo "#!/bin/bash\njava -jar $<" > $@
	chmod +x $@

bin/%.jar : src/%.java
	script/pack_java.rb "$<" "$@"