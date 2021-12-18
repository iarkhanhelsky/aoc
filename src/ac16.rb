class Packet
    attr_reader :end_pos, :type_id, :children

    def initialize(value, version, type_id, end_pos, children)
        @value = value
        @version = version
        @type_id = type_id
        @end_pos = end_pos
        @children = children
    end

    def version_sum
        @version.to_i(2) + children.inject(0) { |a, c| a + c.version_sum }
    end

    def value
        case type_id.to_i(2)
        when 0
            children.inject(0) { |a, c| a + c.value }
        when 1
            children.inject(1) { |a, c| a * c.value }
        when 2
            children.map(&:value).min
        when 3
            children.map(&:value).max
        when 4
            @value
        when 5
            children[0].value > children[1].value ? 1 : 0
        when 6
            children[0].value < children[1].value ? 1 : 0
        when 7
            children[0].value == children[1].value ? 1 : 0
        end
    end
end
class Decoder
    HEX_TO_BIN = {
        '0' => '0000',
        '1' => '0001',
        '2' => '0010',
        '3' => '0011',
        '4' => '0100',
        '5' => '0101',
        '6' => '0110',
        '7' => '0111',
        '8' => '1000',
        '9' => '1001',
        'A' => '1010',
        'B' => '1011',
        'C' => '1100',
        'D' => '1101',
        'E' => '1110',
        'F' => '1111'
    }

    def initialize(str)
        @packet = hex_to_bin(str)
        @version_sum = 0
    end

    def hex_to_bin(string)
        string.chars.inject('') { |a, c| a + HEX_TO_BIN[c] }
    end

    def decode!
        decode(@packet, 0)
    end

    def decode(packet, pos)
        version = packet[pos..(pos + 2)]
        type_id = packet[(pos + 3)..(pos + 5)]

        debug "!v: #{version} #{version.to_i(2)}"
        debug "!t: #{type_id} #{type_id.to_i(2)}"
        debug packet[pos..]

        @version_sum += version.to_i(2)

        if type_id == '100'    
            value, pos = *decode_literal(packet, pos + 6) 
            children = []
        else
            value = nil
            children, pos = *decode_operator(packet, pos + 6)
        end

        Packet.new(value, version, type_id, pos, children)
    end

    def decode_literal(packet, pos)
        debug "!decode_literal: #{pos}"
        stop = false
        result = ''
        while !stop do
            val = packet[pos..(pos + 4)]
            stop = val[0] == '0'
            result += val[1..]
            pos = pos + 5
        end
    
        [result.to_i(2), pos]
    end

    def decode_operator(packet, pos)
        debug "!decode_operator: #{pos}"
        mode = packet[pos]
        pos = pos + 1
        children = []

        if mode == '0'
            debug "!decode_operator: mode 0"
            bits = packet[pos..(pos + 14)]
            debug "!decode_operator: rest #{bits}"
            pos = pos + 15
            len = bits.to_i(2)
            debug "!decode_operator: len #{len}"
    
            last = pos + len
            while pos < last
                debug "!decode_operator: #{pos} < #{pos + len} (#{len}, #{packet.length})"
                p = decode(packet, pos)
                children << p
                pos = p.end_pos
            end
        else
            debug "!decode_operator: mode 1"
            bits = packet[pos..(pos + 10)]
            debug "!decode_operator: rest #{bits}"
            count = bits.to_i(2)
            pos = pos + 11
            debug "!decode_operator: times #{count}"
            count.times do 
                p = decode(packet, pos)
                children << p
                pos = p.end_pos
            end
        end

        [children, pos]
    end

    def debug(*args)
        # puts(*args)
    end
end

# CHECKS = {
#     'EE00D40C823060' => 0,
#     '8A004A801A8002F478' => 16,
#     '620080001611562C8802118E34' => 12,
#     'C0015000016115A2E0802F182340' => 23,
#     'A0016C880162017C3686B18A3D4780' => 31
# }

# CHECKS.each do |packet, version_sum|
#     result = Decoder.new(packet).decode!
#     ["#{packet}     exp: #{version_sum}, got: #{result.version_sum}", version_sum != result.version_sum]
# end

def main
    result = Decoder.new(gets.chomp).decode!
    puts "version_sum: #{result.version_sum}"
    puts "value: #{result.value}"
end