input = File.read("input").strip

alias Position = Tuple(Int32, Int32)
alias PositionMap = Hash(Position, String)

numbers = input
  .split("\n")
  .map_with_index { |x, i| {x, i} }
  .reduce(PositionMap.new) do |number_map, (line, line_number)|
    line_numbers = line.scan(/\d+/).reduce(PositionMap.new) do |line_number_map, number|
      line_number_map.merge({ {number.begin, line_number} => number[0] })
    end
    number_map.merge(line_numbers)
  end

symbols = input
  .split("\n")
  .map_with_index { |x, i| {x, i} }
  .reduce(PositionMap.new) do |symbol_map, (line, line_number)|
    line_symbols = line.scan(/[^(\d|.)]/).reduce(PositionMap.new) do |line_symbol_map, symbol|
      line_symbol_map.merge({ {symbol.begin, line_number} => symbol[0] })
    end
    symbol_map.merge(line_symbols)
  end

part1 = numbers.select do |(x, y), number|
  adjacent_to_symbol = false
  ((y - 1)..(y + 1)).each do |y|
    ((x - 1)..(x + number.size)).each do |x|
      if symbols.has_key?({x, y})
        adjacent_to_symbol = true
      end
    end
  end
  adjacent_to_symbol
end.values.map(&.to_i).sum

puts part1

part2 = symbols.reduce(0) do |sum, ((x, y), symbol)|
  adjacent_numbers = [] of Int32
  if symbol == "*"
    ((y - 1)..(y + 1)).each do |j|
      ((x - 3)..(x + 1)).each do |i|
        number = numbers[{i, j}]?
        if !number.nil? && number.size + i >= x
          adjacent_numbers.push(number.to_i)
        end
      end
    end
    sum += adjacent_numbers.product if adjacent_numbers.size == 2
  end
  sum
end

puts part2