class Solution
    def follow(directions, cells)
        cell_id = "AAA"
        return 0 unless cells[cell_id]
        
        it = 0
        while cell_id != "ZZZ" do
            direction = directions[it % directions.size]
            idx = (direction == "L" ? 0 : 1)
            cell_id = cells[cell_id][idx]
            it += 1
        end 

        it
    end

    def follow2(directions, cells)
        cell_ids = cells.keys.select { |x| x.end_with?('A') }
        
        its = cell_ids.map do |cell_id|
            visited = []
            c = cell_id
            it = 0

            while !c.end_with?('Z')
                visited << c
                direction = directions[it % directions.size]               
                idx = (direction == "L" ? 0 : 1)
                c = cells[c][idx]
                
                it += 1
            end

            visited.size
        end

        its.inject(1) { |a, v| a.lcm(v) }
    end

    def run(lines)
        directions = lines.shift.chars
        lines.shift # separator
        cells = lines.map { |l| l.scan(/[A-Z0-9]*/).select {|x| x != "" } }
                     .inject({}) { |a, c| a.update(c.first => c[1..2]) }

        [
            follow(directions, cells),
            follow2(directions, cells)
        ]
    end
end
