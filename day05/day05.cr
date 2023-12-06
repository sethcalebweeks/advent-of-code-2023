input = File.read("input").strip

class Map

  @ranges : Hash(Range(Int64, Int64), Int64)

  def initialize(@ranges = {} of Range(Int64, Int64) => Int64)
  end

  def self.from_str(str)
    map = self.new
    str.split("\n")[1..].map do |range|
      destination, source, length = range.split(' ')
      source_range = (source.to_i64..(source.to_i64 + length.to_i64 - 1))
      map.add_range(source_range, destination.to_i64)
    end
    map
  end

  def add_range(range, value)
    @ranges[range] = value
  end

  def transform(resource)
    range = @ranges.find { |range, _| range.includes?(resource) }
    range.nil? ? resource : (resource - range[0].begin) + range[1]
  end
  
end

seeds, *maps = input.split("\n\n")
seeds = seeds.lchop("seeds: ").split(' ').map(&.to_i64)
resource_maps = maps.map { |str| Map.from_str(str) }

part1 = seeds.map do |seed|
  resource_maps.reduce(seed) do |result, map|
    map.transform(result)
  end
end.min

seeds = (seeds[14]..(seeds[14] + seeds[15] - 1)).each

part2 = seeds.reduce(6472060) do |min, seed|
  location = resource_maps.reduce(seed) do |result, map|
    map.transform(result)
  end
  Math.min(min, location)
end

puts part2
