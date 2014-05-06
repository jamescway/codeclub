#!/usr/bin/ruby

def start_processing?(str)
  %w(Dy MxT MnT).each do |s|
    return false unless str.include?(s)
  end
  return true
end

def is_monthly_average(str)
  str.include?("mo")
end

def to_num(str)
  str.gsub(/\D/, '').to_f if str
end

def parse_tokens(str)
  tokens = str.split(/\s/)
  tokens.map{|m| tokens.delete(m) if m==nil || m==""}
  tokens
end


file = File.open("weather.dat", "r")

lines = file.readlines
processing = false
min_spread = {:day => "", :spread => 999999}

lines.each_with_index do |line, index|
  begin
    next if line.strip.empty?
    #puts "#{index}: #{line}"
    if start_processing?(line)
      processing = true
      next
    end
    break if line.include?("</pre>") 
    next if is_monthly_average(line)

    if processing
      tokens = parse_tokens(line)      
      spread = to_num(tokens[1]) - to_num(tokens[2])
      if(spread < min_spread[:spread])
        min_spread[:day]    = tokens[0]
        min_spread[:spread] = spread
      end
    end
  rescue => e
    puts "Line(#{index}): " + e.message
    next
  end
end

puts "FINAL MIN SPREAD: day: #{min_spread[:day]}  spread:#{min_spread[:spread]}"