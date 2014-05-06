#!/usr/bin/ruby

BREAK_STRINGS = %w(</pre>)



def start_processing?(str)
  str.include?("Team")
end

def is_unnecessary?(str)
  str.include?("-------------") or 
  str.strip.empty?
end

def to_num(str)
  str.gsub(/\D/, '').to_f if str
end

def parse_tokens(str)
  tokens = str.split(/\s/)
  tokens.map{|m| tokens.delete(m) if m==nil || m==""}
  tokens
end

def should_break?(str)
  BREAK_STRINGS.each do |s|
    return true if str.include?(s)
  end
  false
end



file = File.open("football.dat", "r")

lines = file.readlines
processing = false
min_spread = {:team => "", :spread => 999999}

lines.each_with_index do |line, index|
  begin
    next if is_unnecessary?(line)
    #puts "#{index}: #{line}"
    if start_processing?(line)
      processing = true
      next
    end
    break if should_break?(line) 

    if processing
      tokens = parse_tokens(line)      
      spread = to_num(tokens[6]) - to_num(tokens[8])
      spread = spread.to_f.abs
      #puts "Team: #{tokens[1]} spread:#{spread}   #{tokens[6]} - #{tokens[8]}"
      if(spread < min_spread[:spread])
        min_spread[:team]    = tokens[1]
        min_spread[:spread] = spread
      end
    end
  rescue => e
    puts "Line(#{index}): " + e.message
    next
  end
end

puts "FINAL MIN SPREAD: Team: #{min_spread[:team]}  spread:#{min_spread[:spread]}"