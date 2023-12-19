class Solution
    def parse(lines)
        workflows = []
        parts = []
        
        lines.each do |line|
            if line =~ /^[a-z]+/
                name = line[/^[a-z]*/]
                conditions = line[name.size+1..-2]
                
                conditions = conditions.split(',')
                                       .map { |c| c.split(':') }
                                       .map { |c, w| c =~ /^[A-Za-z]*$/ ? {action: c} : {selector: c[0], op: c[1], value: c[2..].to_i, action: w} }

                workflows << [name, conditions]
            elsif line.size > 0
                part = line.scan(/[a-z]*=[0-9]*/)
                           .map { |x| x.split('=')}
                           .inject({}) { |a, e| a.update(e.first => e.last.to_i) }
                parts << part
            end
        end
        
        [workflows, parts]
    end

    def match_workflow(part, conditions)
        conditions.each do |c|
            if c.size == 1
                return c[:action] 
            end

            cmp = c[:op] == '<' ? -1 : 1
            return c[:action]  if (part[c[:selector]] <=> c[:value]) == cmp
        end
    end

    def run_workflows(parts, workflows)
        accepted = []
        while !parts.empty?
            part = parts.pop

            i = workflows.index { |w| w.first == 'in' }
            while true
                action = match_workflow(part, workflows[i][1])
                case action
                when 'R'
                    break
                when 'A'
                    accepted << part
                    break
                else
                    i = workflows.index { |w| w.first == action }
                end
            end

        end

        accepted
    end

    def estimate_workflows(workflows)        
        accepted = []
        parts = [
          ['in' , {'x' => [1, 4000], 'm' => [1, 4000], 'a' => [1, 4000], 's' => [1, 4000] } ]
        ]

        while !parts.empty?
            name, part = *parts.pop
            
            if name == 'A'
                accepted << part
                next
            elsif name == 'R'
                next
            end
            
            i = workflows.index { |w| w.first == name }
            workflows[i][1].each do |c|                    
                if c == { action: 'A' }
                    parts << [ 'A', part ]
                elsif c == { action: 'R' }
                    parts << ['R', part ]
                elsif c.size == 1
                    parts << [c[:action], part]
                else
                    value = c[:value]
                    op = c[:op]
                    selector = c[:selector]

                    range = part[selector]
                    if op == '>'
                        l = value + 1
                        r = range[1]

                        ln = range[0]
                        rn = value
                    else
                        l = range[0]
                        r = value - 1

                        ln = value
                        rn = range[1]
                    end

                    if l < r
                        p0 = part.dup
                        p0[selector] = [l, r]
                        parts << [c[:action], p0]
                    end

                    if ln < rn
                        part[selector] = [ln, rn]
                    else
                        part = {'x' => [0, 0], 'm' => [0, 0], 'a' => [0, 0], 's' => [0, 0] }
                    end
                end
            end
        end

        accepted
    end

    def count_parts(accepted_ranges)
        accepted_ranges.map { |r| r.values.map { |l, r| r - l + 1 }.inject(&:*) }
                       .sum
    end

    def run(lines)
        workflows, parts = parse(lines)

        [
            run_workflows(parts, workflows).flat_map { |p| p.values }.sum,
            count_parts(estimate_workflows(workflows))
        ]
    end
end
