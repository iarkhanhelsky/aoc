require 'set'
require 'benchmark'

def read_caves
    paths = {}
    ARGF.each do |line|
        line = line.chomp
        next if line.empty?

        s, f = line.split('-')

        paths[s] = [] unless paths.key?(s)
        paths[f] = [] unless paths.key?(f)

        paths[s] << f
        paths[f] << s
    end

    paths
end

def find_paths(graph, node, allow_cave = nil, allow_count = 0, visited = [])
    if node == 'end'
        return [(visited + ['end']).join(',')]
    end
    if node == allow_cave
        return [] if allow_count > 2
    else
        return [] if node != node.upcase && visited.include?(node)
    end

    v = visited.dup
    v << node

    allow_count = allow_count + 1 if allow_cave == node

    neighbours = graph[node]
    neighbours.inject([]) do |a, n|
        a + find_paths(graph, n, allow_cave, allow_count, v)
    end
end

def find_all(graph)
    graph.keys
         .select { |x| x != 'start' && x == x.downcase }
         .inject([]) { |a, e| a + find_paths(graph, 'start', e, 1) }
         .uniq
end

def main
    graph = read_caves
    puts find_paths(graph, 'start').size
    puts find_all(graph).size
end

# Benchmark.bm do |x|
#     x.report { |x| 10000.times { 'AX' == 'AX'.upcase } }
#     x.report { |x| 10000.times { 'AX'.match(/[A-Z]*/) } }
#     x.report { |x| 10000.times { 'AX'.match(/\p{Upper}*/) } }
# end
#       user     system      total        real
# 0.002487   0.000049   0.002536 (  0.002532)
# 0.003640   0.000066   0.003706 (  0.003708)
# 0.003695   0.000024   0.003719 (  0.003718)