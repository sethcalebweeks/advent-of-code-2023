input = File.read("input").strip

time, distance = input.split("\n").map do |line|
  line.scan(/\d+/).map(&.[0].to_i)
end

pairs = time.zip(distance)

part1 = pairs.map do |time, distance|
  (1..(time - 1)).map { |x| x * (time - x) }.count { |x| x > distance }
end.product

puts part1

time, distance = input.split("\n").map do |line|
  line.gsub(' ', "").scan(/\d+/)[0][0].to_i64
end

part2 = time - (1..(time - 1)).take_while do |x|
  x.to_i64 * (time - x.to_i64) <= distance
end.size * 2 - (time % 2 == 0 ? 1 : 0)

puts part2
