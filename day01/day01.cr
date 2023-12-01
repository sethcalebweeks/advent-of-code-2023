require "string_scanner"

input = File.read("input").strip

part1 = input.split("\n").map do |line|
  digits = line.scan(/\d/).map(&.[0])
  (digits[0] + digits[digits.size - 1]).to_i
end.sum

puts part1

ordinal = {
  "one" => "1",
  "two" => "2",
  "three" => "3",
  "four" => "4",
  "five" => "5",
  "six" => "6",
  "seven" => "7",
  "eight" => "8",
  "nine" => "9"
}

part2 = input.split("\n").map do |line|
  digits = [] of String
  scanner = StringScanner.new(line)
  while !scanner.eos?
    match = scanner.scan_until(/\d|one|two|three|four|five|six|seven|eight|nine/)
    digit = scanner[0]?
    break if digit.nil?
    if digit.size > 1
      scanner.offset = scanner.offset - digit.size + 1
    end
    digits.push(ordinal[digit]? || digit)
  end
  (digits[0] + digits[digits.size - 1]).to_i
end.sum

puts part2