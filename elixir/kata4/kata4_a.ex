defmodule Kata4 do
  def modulename do
    IO.puts "this is kata4"
  end

  def loadFile do
    {:ok, file} = File.open("weather.dat", [:read])
    IO.read(file, :line)
    IO.read(file, :line)
    IO.read(file, :line)
    IO.read(file, :line)
    IO.read(file, :line)
    IO.read(file, :line)
    IO.read(file, :line)
    IO.read(file, :line)
    max = readlines(file, 0)
    IO.puts("Biggest diff temp: #{max}")
    File.close(file)
  end

  def readlines(file, max) do
    line = IO.read(file, :line)

    if(line != :eof) do
      tokens = String.split(line)
      if length(tokens) > 1 do
        day = Enum.at tokens, 0
        mx = elem(Integer.parse("#{String.strip("#{Enum.at tokens, 1}", ?*)}"), 0)
        mn = elem(Integer.parse("#{String.strip("#{Enum.at tokens, 2}", ?*)}"), 0)
        dif = mx - mn
        IO.puts "Day:#{day} #{mx} #{mn} Dif[#{dif}] CurrentMax[#{max}]"
        if dif > max do
          IO.puts("Update DIF: #{dif}")
          max = dif
        end

        max = readlines(file,max)
      end
    end
    max
  end
end

Kata4.loadFile
