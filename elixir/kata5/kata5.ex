defmodule BloomFilter do
  def initialize_filter(bloom_filter) do
    {:ok, file} = File.open("simple_words", [:read])
    bloom_filter = load_words(file, bloom_filter)
    File.close(file)
    bloom_filter
  end

  def load_words(file, bloom_filter) do
    word = IO.read(file, :line)

    if(word != :eof) do
      len = length(bloom_filter)
      word = String.strip(word)
      IO.puts "Word: #{word}"
      md5 = Crypto.generate(:md5, word, len)
      md4 = Crypto.generate(:md4, word, len)
      sha = Crypto.generate(:sha, word, len)
      IO.puts "md5: #{md5}"
      IO.puts "md4: #{md4}"
      IO.puts "sha: #{sha}"
      bloom_filter = set_hashes(bloom_filter, md5, md4, sha)
      load_words(file, bloom_filter)
    else
      bloom_filter
    end
  end

  def set_hashes(bloom_filter, md5, md4, sha) do
    res = set_hash(bloom_filter, [], md5, length(bloom_filter))
    res = set_hash(res, [], md4, length(bloom_filter))
    set_hash(res, [], sha, length(bloom_filter))
  end

  def set_hash(old_bloom_filter, new_bloom_filter, position, size) do
    if(size == 0) do
      new_bloom_filter
    else
      if(position == size) do
        set_hash(old_bloom_filter, [1 | new_bloom_filter], position, size - 1)
      else
        set_hash(old_bloom_filter, [Enum.at(old_bloom_filter, size) | new_bloom_filter], position, size - 1)
      end
    end
  end

  def create_filter(size, filter) do
    if(size == 0) do
      filter
    else
      create_filter(size - 1, [0 | filter])
    end
  end
end

defmodule Crypto do
  def generate(type, str, size) do
    {int, _ } = Integer.parse(Enum.join(bitstring_to_list(:crypto.hash(type, str))))
    rem(int, size)
  end
end

bloom_filter_size = 10

filter = BloomFilter.create_filter(bloom_filter_size, [])
IO.inspect filter

bloom_filter = BloomFilter.initialize_filter(filter)
IO.inspect bloom_filter

