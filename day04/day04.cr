input = File.read("input").strip

alias Cards = Hash(Int32, Card)

class Card

  @winning : Array(Int32)
  @have : Array(Int32)
  property count : Int32

  def initialize(@winning, @have, @count = 1)
  end

  def self.from_str(str)
    winning, have = str.split('|')
    winning = winning.scan(/\d+/).map(&.[0].to_i)
    have = have.scan(/\d+/).map(&.[0].to_i)
    self.new(winning, have)
  end

  def wins
    (@winning&(@have)).size
  end

  def worth
    self.wins > 0 ? 2 ** (self.wins - 1) : 0
  end

  def duplicate(times)
    @count += times
  end

end

cards = input.split("\n").reduce(Cards.new) do |cards, line|
  head, body = line.split(':')
  card_number = head.lchop("Card ").to_i
  cards.merge({card_number => Card.from_str(body)})
end

part1 = cards.values.map(&.worth).sum

puts part1

part2 = cards.reduce(0) do |sum, (card_number, card)|
  if card.wins > 0
    ((card_number + 1)..(card_number + card.wins)).each do |number|
      cards[number].duplicate(card.count)
    end
  end
  sum + card.count
end

puts part2
