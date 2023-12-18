input = File.read("input").strip

grid = input.split("\n").map(&.chars)

enum Direction
  Up
  Down
  Left
  Right
end

def move(position, direction)
  row, col = position
  case direction
    in .up? then {row - 1, col}
    in .down? then {row + 1, col}
    in .left? then {row, col - 1}
    in .right? then {row, col + 1}
  end
end

def back_slash(direction)
  case direction
    in .up? then Direction::Left
    in .down? then Direction::Right
    in .left? then Direction::Up
    in .right? then Direction::Down
  end
end

def forward_slash(direction)
  case direction
    in .up? then Direction::Right
    in .down? then Direction::Left
    in .left? then Direction::Down
    in .right? then Direction::Up
  end
end

def in_grid(position, grid)
  row, col = position
  row >= 0 && row < grid.size && col >= 0 && col < grid[row].size
end

def shine(grid, path, start, start_direction)
  edge = false
  position = start
  row, col = position
  direction = start_direction
  while in_grid(position, grid) && !path.includes?({position, direction})
    row, col = position
    path << {position, direction}
    case grid[row][col]
    when '\\'
      direction = back_slash(direction)
    when '/'
      direction = forward_slash(direction)
    when '-'
      if direction.up? || direction.down?
        shine(grid, path, position, Direction::Left)
        shine(grid, path, position, Direction::Right)
        break
      end
    when '|'
      if direction.left? || direction.right?
        shine(grid, path, position, Direction::Up)
        shine(grid, path, position, Direction::Down)
        break
      end
    else
    end
    position = move(position, direction)
  end
end

part1 = begin
  path = [] of Tuple(Tuple(Int32, Int32), Direction)
  shine(grid, path, {0, 0}, Direction::Right)
  path.map(&.[0]).uniq.size  
end

puts part1

part2 = begin
  max = 0
  (0...110).each do |i|
    path = [] of Tuple(Tuple(Int32, Int32), Direction)
    shine(grid, path, {0, i}, Direction::Down)
    max = Math.max(max, path.map(&.[0]).uniq.size)
  end
  (0...110).each do |i|
    path = [] of Tuple(Tuple(Int32, Int32), Direction)
    shine(grid, path, {109, i}, Direction::Up)
    max = Math.max(max, path.map(&.[0]).uniq.size)
  end
  (0...110).each do |i|
    path = [] of Tuple(Tuple(Int32, Int32), Direction)
    shine(grid, path, {i, 0}, Direction::Right)
    max = Math.max(max, path.map(&.[0]).uniq.size)
  end
  (0...110).each do |i|
    path = [] of Tuple(Tuple(Int32, Int32), Direction)
    shine(grid, path, {i, 109}, Direction::Left)
    max = Math.max(max, path.map(&.[0]).uniq.size)
  end
  max  
end

puts part2
