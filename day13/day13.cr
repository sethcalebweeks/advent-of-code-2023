require "levenshtein"

input = File.read("input").strip

patterns = input.split("\n\n")


def find_mirror(rows, distance = 0)
  mirror = 0
  (1...rows.size).each do |i|
    edge = Math.min(i, rows.size - i)
    image = rows[i - edge...i].join
    reflection = rows[i...i + edge].reverse.join
    mirror = i if Levenshtein.distance(image, reflection) == distance
  end
  mirror
end

part1 = patterns.reduce(0) do |sum, pattern|
  rows = pattern.split("\n")
  cols = Array.new(rows[0].size, "")
  rows.each do |row|
    row.each_char.with_index do |char, col|
      cols[col] += char
    end
  end
  sum + find_mirror(rows) * 100 + find_mirror(cols)
end

puts part1

part2 = patterns.reduce(0) do |sum, pattern|
  rows = pattern.split("\n")
  cols = Array.new(rows[0].size, "")
  rows.each do |row|
    row.each_char.with_index do |char, col|
      cols[col] += char
    end
  end
  sum + find_mirror(rows, 1) * 100 + find_mirror(cols, 1)
end

puts part2
