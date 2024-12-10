#!/usr/bin/env ruby

class Record
  attr_accessor :id, :position, :size
  def initialize(id, position, size)
    @id = id
    @position = position
    @size = size
  end
end

class Space
  attr_accessor :position, :size
  def initialize(position, size)
    @position = position
    @size = size
  end
end

blocks = Array.new
records = Array.new
spaces = Array.new

id = 0
pos = 0
ARGF.read.chars.map { |c| Integer(c) }.each_slice(2) do |a, b|
  blocks += Array.new(a, id)
  blocks += Array.new(b, nil) unless b.nil?

  records << Record.new(id, pos, a)
  spaces << Space.new(pos+a, b) unless b.nil?
  id += 1
  pos += a
  pos += b unless b.nil?
end

head = 0
tail = blocks.size - 1

while tail > head
  while ! blocks[head].nil? && tail > head
    head += 1
  end
  while blocks[tail].nil? && tail > head
    tail -= 1
  end
  blocks[head] = blocks[tail]
  blocks[tail] = nil
end

sum = 0
(0...blocks.size).each do |i|
  sum += i * blocks[i] unless blocks[i].nil?
end

puts sum

# Part 2

records.reverse_each do |r|

  #puts "Trying to move record: #{r.id}"

  spaces.each do |s|
    break if s.position > r.position

    if r.size <= s.size
      #puts "  New position: #{s.position}"
      r.position = s.position
      s.position += r.size
      s.size -= r.size
      break
    end
  end
end

sum = 0
records.each do |r|
  (r.position...r.position+r.size).each do |i|
    sum += i * r.id
  end
end

puts sum