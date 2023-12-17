input = File.read("input").strip

rows = input.split("\n").map(&.chars)

def tilt(rows)
  (1...rows.size).each do |row_num|
    (0...row_num).each do |prev|
      current_row = row_num - prev
      row_above = current_row - 1
      stones = rows[current_row].join.scan(/O/).map(&.begin)
      stones.each do |stone|
        if rows[row_above][stone] == '.'
          rows[row_above][stone] = 'O'
          rows[current_row][stone] = '.'
        end
      end
    end
  end
end

def weigh(rows)
  (0...rows.size).reduce(0) do |sum, row_num|
    sum + rows[row_num].join.scan("O").size * (rows.size - row_num)
  end
end

part1 = begin
  tilt(rows) 
  weigh(rows)
end

puts part1

cache = Set(String).new

part2 = begin
  last = -1
  current = 0
  i = 1
  cycle_start = nil
  cycle = Array(Int32).new
  while !cycle_start || !cycle.group_by { |x| x }.values.map { |x| x.size > 4 }.all?
    if i % 4 == 1
      cycle_start = i if last == current
      weight = weigh(rows)
      cycle.push(weight) if cycle_start
      cache.add(rows.map(&.join).join("\n"))
      last = current
      current = cache.size
    end
    tilt(rows)
    rows = rows.reverse.transpose
    i += 1
  end
  cycle = cycle[...cycle.size // 5]
  cycle[(4_000_000_000 - i + 4) % cycle.size]
end

puts part2
