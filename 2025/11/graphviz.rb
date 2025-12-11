puts "digraph G {"
ARGF.each do |l|
  input, outputs = *l.split(':')
  outputs.split(' ').each do |o|
    puts "    #{input} -> #{o}"
  end
end
puts "}"