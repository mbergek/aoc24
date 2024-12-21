#!/usr/bin/env ruby

require "matrix"

def get(pos)
  return "#" if offside(pos)
  $matrix[pos[1]][pos[0]]
end

def set(pos, c) 
  return if offside(pos)
  $matrix[pos[1]][pos[0]] = c
end

def get_score
  score = 0
  (0...$matrix[0].size).each do |x|
    (0...$matrix.size).each do |y|
      if get(Vector[x, y]) == 'O'
        score += y*100 + x
      end
    end
  end
  return score
end

def find_robot
  (0...$matrix[0].size).each do |x|
    (0...$matrix.size).each do |y|
      if get(Vector[x, y]) == '@'
        return Vector[x, y]
      end
    end
  end
  return nil
end

def move(pos, vec)
  # Follow the direction until a space or wall is found
  p = pos
  while get(p) =~ /[@O]/
    p += vec
  end

  # If a wall was found, then just return
  return pos if get(p) == "#"

  # If a space was found then move all boxes and the robot one position
  while get(p) =~ /[O\.]/
    set(p, get(p - vec))
    p -= vec
  end
  set(p, '.')

  # Return the new position of the robot
  return pos + vec
end

def offside(pos)
  return true if pos[1] < 0 || pos[1] >= $matrix.size
  return true if pos[0] < 0 || pos[0] >= $matrix[pos[1]].size
  return false
end

data = []
state = :map
movements = ""
ARGF.each do |line|
  line.chomp! 
  state = :list if line.empty?

  case state
  when :map
    data << line.chars
  when :list
    movements += line
  end
end

$matrix = data

#pp $matrix
#puts movements

# Get starting position
position = find_robot

movements.chars.each do |c|
  case c
  when '>'
    v = Vector[1, 0]
  when 'v'
    v = Vector[0, 1]
  when '<'
    v = Vector[-1, 0]
  when '^'
    v = Vector[0, -1]
  end

  position = move(position, v)
end

#pp $matrix
puts get_score
