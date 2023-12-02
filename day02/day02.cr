input = File.read("input").strip

alias Games = Hash(Int32, Subsets)
alias Subsets = Array(Subset)
alias Subset = Hash(String, Int32)

games = input.split("\n").reduce(Games.new) do |games, line|
  game, subsets = line.split(":")
  game_number = game[5..].to_i
  subsets = subsets.split(';').map do |subset|
    subset.split(',').reduce(Subset.new) do |set, cubes|
      number, color = cubes.strip.split(' ')
      set.merge({color => number.to_i})
    end
  end
  games.merge({game_number => subsets})
end

bag = {
  "red" => 12,
  "green" => 13,
  "blue" => 14
}

part1 = games.select do |game, subsets|
  subsets.map do |subset|
    subset.map { |color, number| number <= bag[color] }.all?
  end.all?
end.keys.sum

puts part1

part2 = games.values.map do |subsets|
  subsets.reduce do |set, cubes|
    set.merge(cubes) { |_, old, new| Math.max(old, new) }
  end.values.product
end.sum

puts part2