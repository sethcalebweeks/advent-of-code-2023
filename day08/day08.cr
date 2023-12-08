input = File.read("input").strip

alias Node = Hash(String, Tuple(String, String))

instruction_str, nodes = input.split("\n\n")

nodes = nodes.split("\n").reduce(Node.new) do |nodes, line|
  node, left, right = line.scan(/\w+/).map(&.[0])
  nodes.merge({node => {left, right}})
end

part1 = begin
  instructions = instruction_str
    .gsub({L: 0, R: 1})
    .each_char
    .map(&.to_i)
    .cycle
  steps = 0
  current_node = "AAA"
  while current_node != "ZZZ"
    steps += 1
    current_node = nodes[current_node][instructions.next.as(Int32)]
  end
  steps
end

puts part1

part2 = begin
  instructions = instruction_str
    .gsub({L: 0, R: 1})
    .each_char
    .map(&.to_i)
    .cycle
  steps = 0
  starting_nodes = nodes.select { |node, _| node.ends_with?('A') }.keys
  current_nodes = starting_nodes
  cycles = Array.new(current_nodes.size, 0_i64)
  cycle_counts = Array.new(current_nodes.size, 0)
  while cycle_counts.map { |x| x < 2 }.all?
    steps += 1
    step = instructions.next.as(Int32)
    current_nodes = current_nodes.map_with_index do |node, i|
      cycle_counts[i] += 1 if node.ends_with?('Z')
      cycles[i] = steps - cycles[i] - 1 if node.ends_with?('Z')
      nodes[node][step]
    end
  end
  cycles.reduce { |lcm, cycle| lcm.lcm(cycle) }
end

puts part2
