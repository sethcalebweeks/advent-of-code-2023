input = File.read("input").strip

lines = input.split("\n")

galaxies = lines.map_with_index do |line, row|
  line.scan(/#/).map { |match| {row, match.begin} }
end.flatten

empty_rows = (0..(lines.size - 1)).select do |row|
  !galaxies.find { |(x, _)| x == row }
end

empty_cols = (0..(lines[0].size - 1)).select do |col|
  !galaxies.find { |(_, y)| y == col }
end

expanded_universe = galaxies.map do |x, y|
  {
    x + empty_rows.select { |row| row < x }.size,
    y + empty_cols.select { |col| col < y }.size
  }
end

part1 = begin
  lengths = 0
  expanded_universe.each_cartesian(expanded_universe) do |(x1, y1), (x2, y2)|
    if {x1, y1} < {x2, y2}
      lengths += (x2 - x1).abs + (y2 - y1).abs
    end
  end
  lengths
end

puts part1

older_universe = galaxies.map do |x, y|
  {
    x.to_i64 + (empty_rows.select { |row| row < x }.size.to_i64 * 999_999_i64),
    y.to_i64 + (empty_cols.select { |col| col < y }.size.to_i64 * 999_999_i64)
  }
end

part2 = begin
  lengths = 0_i64
  older_universe.each_cartesian(older_universe) do |(x1, y1), (x2, y2)|
    if {x1, y1} < {x2, y2}
      lengths += (x2 - x1).abs + (y2 - y1).abs
    end
  end
  lengths
end

puts part2
