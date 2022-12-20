#!/usr/bin/env ruby
require 'fileutils'
require 'tmpdir'

include FileUtils::Verbose

source = ARGV[0]
output = File.expand_path(ARGV[1])

puts "SRC: #{source}"
puts "OUT: #{output}"

Dir.mktmpdir do |path|
    puts "TMP: #{path}"
    mkdir_p(File.join(path, 'META-INF'))
    manifest = File.join(path, 'META-INF', 'MANIFEST.MF')
    puts `javac #{source} -d #{path}`
    puts "MF:  #{manifest}"
    IO.write(manifest, "Main-Class: #{File.basename(source, '.java')}\n")
    Dir.chdir(path) { puts `zip -r #{output} *` } 
end