input = File.read("input").strip

# input = "
# ???.### 1,1,3
# .??..??...?##. 1,1,3
# ?#?#?#?#?#?#?#? 1,3,1,6
# ????.#...#... 4,1,1
# ????.######..#####. 1,6,5
# ?###???????? 3,2,1".strip

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

def spacing(row, arr)
  if arr.size == 1
    (0..row.size - arr[0]).reduce([] of String) do |sub, i|
      spacing = "." * i + "#" * arr[0] + "." * (row.size - arr[0] - i)
      valid_spacing(row, spacing) ? sub << spacing : sub
    end
  else
    to = row.size - arr[1..].size - arr[1..].sum - arr[0]
    (0..to).flat_map do |i|
      prefix = "." * i + "#" * arr[0] + "."
      if valid_spacing(row[...prefix.size], prefix)
        spacing(row[i + arr[0] + 1..], arr[1..]).reduce([] of String) do |acc, sub|
          spacing = prefix + sub
          valid_spacing(row, spacing) ? acc << spacing : acc
        end
      else
        [] of String
      end
    end
  end
end

puts spacing(conditions[3][0].strip('.'), conditions[3][1])

part1 = conditions.reduce(0) do |sum, (row, distribution)|
  sum + spacing(row, distribution)
    .select { |spacing| valid_spacing(row, spacing)}
    .size
end

puts part1


unfolded = conditions.map do |row, distribution|
  {[row, row, row, row, row].join("?"), distribution * 5}
end

part2 = unfolded[142..].reduce(0_i64) do |sum, (row, distribution)|
  thing = spacing(row, distribution).size
  File.write("output", "#{thing}\n", mode: "a") # testing code
  puts thing # testing code
  sum + thing
end

puts part2
