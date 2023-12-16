input = File.read("input").strip

conditions = input.split("\n").map do |line|
  row, distribution = line.split(' ')
  {row, distribution.split(',').map(&.to_i)}
end

def valid_spacing(row, spacing)
  valid = true
  row.each_char.zip(spacing.each_char).each do |condition, guess|
    valid = false if condition == '#' && guess != '#'
    valid = false if condition == '.' && guess != '.'
  end
  valid
end

cache = Hash(Tuple(String, Array(Int32)), Int64).new()

def spacing(row, arr, cache)
  if cache.has_key?({row, arr})
    cache[{row, arr}]
  elsif arr.size == 1
    arrangements = (0..row.size - arr[0]).reduce(0_i64) do |sum, i|
      spacing = "." * i + "#" * arr[0] + "." * (row.size - arr[0] - i)
      valid_spacing(row, spacing) ? sum.to_i64 + 1 : sum.to_i64
    end
    cache[{row, arr}] = arrangements
    arrangements
  else
    to = row.size - arr[1..].size - arr[1..].sum - arr[0]
    arrangements = (0..to).reduce(0_i64) do |sum, i|
      prefix = "." * i + "#" * arr[0] + "."
      if valid_spacing(row[...prefix.size], prefix)
        sum.to_i64 + spacing(row[i + arr[0] + 1..], arr[1..], cache)
      else
        sum.to_i64
      end
    end
    cache[{row, arr}] = arrangements
    arrangements
  end
end

part1 = conditions.reduce(0) do |sum, (row, distribution)|
  sum + spacing(row, distribution, cache)
end

puts part1

unfolded = conditions.map do |row, distribution|
  {[row, row, row, row, row].join("?"), distribution * 5}
end

part2 = begin
  unfolded = conditions.map do |row, distribution|
    {[row, row, row, row, row].join("?"), distribution * 5}
  end
  unfolded.reduce(0_i64) do |sum, (row, distribution)|
    sum + spacing(row, distribution, cache)
  end
end

puts part2
