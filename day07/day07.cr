input = File.read("input").strip

cards = input.split("\n").map do |line|
  card, bid = line.split(' ')
  bid = bid.to_i
  card = card.gsub({T: ':', J: ';', Q: '<', K: '=', A: '>'})
  {card, bid}
end

def type(a)
  cases = {
    [] of Int32 => 7,
    [1] => 7,
    [2] => 7,
    [1, 1] => 6,
    [3] => 7,
    [1, 2] => 6,
    [1, 1, 1] => 4,
    [4] => 7,
    [1, 3] => 6,
    [2, 2] => 5,
    [1, 1, 2] => 4,
    [1, 1, 1, 1] => 2,
    [5] => 7,
    [1, 4] => 6,
    [2, 3] => 5,
    [1, 1, 3] => 4,
    [1, 2, 2] => 3,
    [1, 1, 1, 2] => 2,
    [1, 1, 1, 1, 1] => 1
  }

  hand = a
    .gsub('1', "")
    .chars
    .group_by { |x| x }
    .values
    .map(&.size)
    .sort

  cases[hand]? || 1
end

def stronger_hand(a, b)
  compare_type = type(a) <=> type(b)
  compare_type == 0 ? a <=> b : compare_type
end

part1 = cards
  .sort { |(a, _), (b, _)| stronger_hand(a, b) }
  .map_with_index(1) { |(_, bid), i| bid * i }
  .sum

puts part1

part2 = cards
  .map { |card, bid| {card.gsub(';', '1'), bid} }
  .sort { |(a, _), (b, _)| stronger_hand(a, b) }
  .map_with_index(1) { |(_, bid), i| bid * i }
  .sum

puts part2
