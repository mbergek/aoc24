#!/usr/bin/env ruby

require "matrix"

class Entity
  attr_accessor :board, :position, :type

  def has_neighbour?(direction)
    return neighbours(direction).size != 0
  end
  
  def neighbours(direction)
    neighbours = []
    if type != :bigbox
      n = board.get(position + direction)
      neighbours << n if n
    else
      if direction[0] > 0
        n = board.get(position + Vector[1, 0] + direction)
        neighbours << n if n
      else
        if direction[1] != 0
          n1 = board.get(position + direction)
          n2 = board.get(position + Vector[1, 0] + direction)
          if ( n1 && n2 ) && (n1.position == n2.position)
            neighbours << n1
          else
            neighbours << n1 if n1
            neighbours << n2 if n2
          end
        else
          n = board.get(position + direction)
          neighbours << n if n
        end
      end
    end
    return neighbours
  end

  def can_move?(direction)
    return false if type == :wall
    ns = neighbours(direction)
    return true if ns.size == 0
    return ns.inject(true) { |s,v| s && v.can_move?(direction) }
  end

  def move(direction)
    neighbours(direction).each { |n| n.move(direction) }
    board.set(position, nil)
    @position += direction
    board.set(position, self)
  end
  
  def score
    return position[1]*100 + position[0] if type == :box  || type == :bigbox
    
    #if type == :bigbox
    #  cx = [ position[0], board.width-position[0] ].min
    #  cy = [ position[1], board.height-position[1] ].min
    #  #return cy*100 + cx
    #  return position[1]*100 + cx
    #end
    
    return 0
  end
  
  def to_s
    return "#" if @type == :wall
    return "O" if @type == :box
    return "@" if @type == :robot
    return "[]" if @type == :bigbox
    return "."
  end

  def initialize(board, x, y, type)
    @board = board
    @position = Vector[x, y]
    @type = type
  end

end

class Board
  attr_accessor :entities, :map, :robot, :width, :height
  
  def get(pos)
    return nil if offside(pos)
    if @map[pos[1]][pos[0]]
      return @map[pos[1]][pos[0]]
    end
    if @map[pos[1]][pos[0]-1]
      return @map[pos[1]][pos[0]-1] if @map[pos[1]][pos[0]-1].type == :bigbox
    end
    return nil
  end

  def set(pos, obj)
    return if offside(pos)
    @map[pos[1]][pos[0]] = obj
  end

  def offside(pos)
    return true if pos[1] < 0 || pos[1] >= @map.size
    return true if pos[0] < 0 || pos[0] >= @map[pos[1]].size
    return false
  end

  def score
    return entities.inject(0) { |s, v| s + v.score }
  end

  def move(direction)
    return unless @robot.can_move?(direction)
    @robot.move(direction)
  end

  def to_s
    @map.inject("") do |s, v|
      s + v.map { |e| e.nil? ? "." : e.to_s }.join.gsub("].", "]") + "\n"
    end
  end

  def initialize (data)
    @entities = Array.new
    @map = Array.new(data.size) { Array.new(data[0].size) }
    @width = @map[0].size
    @height = @map.size

    (0...data[0].size).each do |x|
      (0...data.size).each do |y|
        case data[y][x]
        when 'O'
          obj = Entity.new(self, x, y, :box)
        when '#'
          obj = Entity.new(self, x, y, :wall)
        when '['
          obj = Entity.new(self, x, y, :bigbox)
        when '@'
          obj = Entity.new(self, x, y, :robot)
          @robot = obj
        end
        if obj
          @map[y][x] = obj
          @entities << obj
        end
      end
    end
  end
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

board1 = Board.new(data)
board2 = Board.new(widen(data))

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

  board1.move(v)
  board2.move(v)
end

puts board1
puts board2

puts board1.score
puts board2.score

