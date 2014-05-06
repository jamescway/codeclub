defmodule Kata4b do
  #didn't know how to globals
  def position1 do
    6
  end

  def position2 do
    8
  end

  def loadFile do
    {:ok, file} = File.open("football.dat", [:read])
    remove_header(file, 5)
    max = readlines(file, 0)
    IO.puts("Biggest diff: #{max}")
    File.close(file)
  end

  def remove_header(file, num_lines) do
    if(num_lines != 0) do
      IO.read(file, :line)
      remove_header(file, num_lines - 1)
    end
  end

  def readlines(file, max) do
    line = IO.read(file, :line)

    if(line != :eof) do
      tokens = String.split(line)
      if length(tokens) > 1 do
        day = Enum.at tokens, 0
        t1 = Enum.at tokens, position1
        t2 = Enum.at tokens, position2
        mx  = elem(Integer.parse("#{String.strip("#{t1}", ?*)}"), 0)
        mn  = elem(Integer.parse("#{String.strip("#{t2}", ?*)}"), 0)
        dif = mx - mn
        IO.puts "#{day} #{mx} #{mn} Dif[#{dif}] CurrentMax[#{max}]"
        if dif > max do
          IO.puts("Update Max: #{dif}")
          max = dif
        end

        max = readlines(file,max)
      end
    end
    max
  end
end

Kata4b.loadFile
