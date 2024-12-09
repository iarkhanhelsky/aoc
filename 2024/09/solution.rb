class Solution
  def defragment1(diskmap, maxid)
    l = 0
    r = diskmap.size - 1 # assuming it to sit on the File block

    lid = 0
    rid = maxid
    
    # remaining count of the right file
    checksum = 0
    pos = 0

    while l <= r
      lfile = diskmap[l]
      lfile.times do |i|
        checksum = checksum + lid * pos
        pos = pos + 1
      end
      diskmap[l] = 0
      
      lfree = diskmap[l+1]
      
      [lfree, diskmap[r]].min.times do |i|
        diskmap[r] -= 1
        diskmap[l+1] -= 1

        checksum = checksum + rid * pos
        pos = pos + 1
      end

      if diskmap[r] == 0
        r -= 2
        rid -= 1
      end 

      if diskmap[l+1] == 0
        l += 2
        lid += 1
      end
    end 

    checksum
  end


  def pprint(exploded)
    exploded.each do |id, pos, used, free|
      print "#{id}" * used + '.' * free 
      
    end
    puts
  end

  def defragment2(diskmap, maxid)
    id = 0
    pos = 0
    exploded = diskmap.each_slice(2).map do |used, free|
      r = [id, pos, used, free || 0]
      id = id + 1 
      pos = pos + used + (free || 0)
      r
    end
    
    cid = maxid
    while cid > 0
      cidx = exploded.index {|id, _, _, _| id == cid }
      candidate = exploded[cidx]
      i = exploded.index { |id, pos, used, free| free >= candidate[2] }
      if i && i < cidx
        nw = [0, candidate[1], 0, candidate[2] + candidate[3]]  
        exploded[cidx] = nw

        lfree = exploded[i][3]
        exploded[i][3] = 0
        exploded.insert(i + 1, [candidate[0], exploded[i][1] + exploded[i][2], candidate[2], lfree - candidate[2]])
      end
      cid -= 1
    end

    checksum = 0
    exploded.each do |id, pos, used, free|
      used.times { |i| checksum += id * (pos + i) }
    end

    checksum
  end

  def run(lines)
    diskmap = lines.first.chars.map(&:to_i)
    used = 0
    free = 0
    count = 0
    diskmap.each_slice(2) { |x, y| used += x; free += (y || 0); count += 1; }

    [
      defragment1(diskmap.dup, count - 1),
      defragment2(diskmap.dup, count - 1)
    ]
  end
end
