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

def move(pos, vec, count, mode = :move)

  #puts "Move #{pos.to_s}, #{vec.to_s}, #{count}, #{mode}"

  unless mode == :move
    return count+1 if get(pos + vec) == '.'
    return 0 if get(pos + vec) == '#'
    return move(pos+vec, vec, count+1, :dry)
  end

  move(pos+vec, vec, count-1, :move) if count > 1
  set(pos+vec, get(pos))
  set(pos, '.')
end

def offside(pos)
  return true if pos[1] < 0 || pos[1] >= $matrix.size
  return true if pos[0] < 0 || pos[0] >= $matrix[pos[1]].size
  return false
end

def widen(m)
  nm = Array.new
  (0...m.size).each do |y|
    row = []
    m[y].each do |v|
      row += ['#', '#'] if v == '#'
      row += ['[', ']'] if v == 'O'
      row += ['.', '.'] if v == '.'
      row += ['@', '.'] if v == '@'
    end
    nm << row
  end
  return nm
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

$matrix = Marshal.load( Marshal.dump(data))

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

  count = move(position, v, 0, :dry)
  if count > 0
    move(position, v, count, :move)
    position = position + v
  end

end

#pp $matrix
puts get_score

