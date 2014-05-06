# require 'ruby-debug'

class LineCounter
  def initialize
    @count = 0
    @commenting = false
  end

  def lines_of_code(file)
    @count = 0

    File.open(file).each_with_index do |line|
      if single_line_comment(line)
        check_block_comments(line)  # check anyway in case theres a /* after the //
      else
        check_block_comments(line)
        if @commenting == false && !ends_with?(line, "*/")
          increment
        end
      end
      puts sprintf("count: %4s -- %6s  | %s ", @count, @commenting, line[0..-2])
    end
    @count
  end

  def single_line_comment(line)
    starts_with?(line,"//") || starts_and_ends_with_comment?(line) || line.strip.empty?
  end

  def increment
    @count += 1
  end

  def check_block_comments(line)
    @commenting = start_comment?(line)
    @commenting = end_comment?(line)
  end

  def starts_and_ends_with_comment?(line)
    line.strip =~ /^(.*)\/\*(.*)/ &&
    line.strip =~ /(.*)\*\/(.*)$/ &&
    @commenting == false
  end

  def start_comment?(line)
    if (line.strip =~ /(.*)\/\*(.*)/) && (@commenting == false)
      increment unless starts_with?(line, "/*") || starts_with?(line, "//")
      true
    else
      @commenting
    end
  end

  def end_comment?(line)
    if (line.strip =~ /(.*)\*\/(.*)/) && (@commenting == true)
      increment unless ends_with?(line, "*/") || starts_with?(line, "//") || start_comment?(line)
      false
    else
      @commenting
    end
  end

  def starts_with?(line, str)
    line.strip[0..1] == str[0..1] rescue false
  end

  def ends_with?(line, str)
    line.strip[-2..-1] == str[0..1] rescue false
  end
end


line_counter = LineCounter.new
puts "C O U N T-1: #{line_counter.lines_of_code("test1").to_s}"
puts "\n"
puts "C O U N T-2: #{line_counter.lines_of_code("test2").to_s}"


# require 'pry'

# LOC
#   - inside of strings are ignored  " to " or ' to '
#     - // in the front after strip
#     - /* to */


#     use cases
#     1. line.strip starts with //
#     2. /* */
#       a. covers entire line
#         -may start on a line (not counted) and finish on a not counted line
#          in between is counted
#       b. if it not terminated, the lines end up getting counted
#             /*  asdf
#                 adsfsdfa
#                  asfdasdfasfd
#             // some comment
#            ==> 2 lines of code









