require "digest"
require "json"

class Network
    attr_reader :journal 

    def initialize(configuration)
        @configuration = configuration.inject({}) { |acc, elem| acc.update(elem[1] => elem) }
        @state = configuration.inject({}) do |acc, elem|
            type, name, targets = *elem
            acc.update(name => {type: type, on: false, inputs: {}})
        end

        @journal = @configuration.keys.inject({}) { |acc, elem| acc.update(elem => []) }

        @state.each do |k, v|
            if v[:type] == '&'
                @configuration.select { |_, m| m[2].include?(k) }
                             .each { |n, _| v[:inputs][n] = 'low' }

            end
        end

    end

    def send(target, pulse, from)
        state = @state[target]

        if target == 'rx' && pulse == 'low'
            @on = true
        end
        return false if state.nil?

        case state[:type]
        when '%'
            if pulse == 'high'
                return false
            else
                state[:next] = state[:on] ? 'low' : 'high'
                state[:on] = !state[:on]
                # puts "#{target}: #{state[:next]} / #{state[:on]}"
            end
        when '&'
            state[:inputs][from] = pulse
            state[:next] = state[:inputs].values.all?{ |x| x == 'high' } ? 'low' : 'high'
        when 'broadcaster'
            state[:inputs][from] = pulse
            state[:next] = pulse
        else

        end

        return true
    end

    def on?
        @configuration.all? { |n, m| !m[2].include?('rx') } || @on
    end

    def push
        queue = ['broadcaster']
        send('broadcaster', 'low', 'button')
        @journal.each { |_, v| v << '|'}
        

        totals = {'low' => 1, 'high' => 0}

        while !queue.empty?
            name = queue.shift
            state = @state[name]
            
            if state[:next].nil?
                puts "#{name}: skip"
                next 
            end

            type, _, targets = @configuration[name]
            pulse = state[:next]
            @journal[name][-1] =  @journal[name][-1] + pulse[0]

            targets.each do |t|
                # puts "#{name}  -#{pulse}-> #{t}"
                totals[pulse] = totals[pulse] + 1
                queue << t if send(t, pulse, name)
            end
        end

        totals
    end
end

class Solution
    def run(lines)
        configuration = lines.map { |l| l.split(' -> ') }
                            .map { |mod, targets| [mod, targets.split(', ')] }
                            .map { |mod, targets| [mod[/^([&%]|broadcaster)/, 1], mod[/[^%&]+/], targets] }

        low = 0
        high = 0
        net = Network.new(configuration)
        100000.times do 
            r = net.push
            low = low + r['low']
            high = high + r['high']
        end

        net.journal.each do |k, v|        
            hist = v.inject({}) { |a, e| a.update(e => ((a[e] || 0) + 1)) }
            puts "#{k}: #{hist.inspect}"
        end

        ['mm', 'ff', 'fk', 'lh'].each do |n|
            next unless net.journal[n]

            print "#{n}: "
            net.journal[n].each_with_index do |e, i|
                if e.start_with?('|hl')
                    print("#{i}, ")
                end
            end

            puts 
        end

        push = 0
        # Network.new(configuration).estimate('rx')
        [low * high, push]
    end
end
