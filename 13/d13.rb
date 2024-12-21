#!/usr/bin/env ruby

require 'parslet'
require 'parslet/convenience'

class Mini < Parslet::Parser
  rule(:cr) { match('[\n]').repeat(0) }
  rule(:eol?) { any.absent? | cr }
  rule(:integer) { match('[+-]').repeat(0) >> match('[0-9]').repeat(1) }
  rule(:btnA) { str('Button A: X') >> integer.as(:x1) >> str(', Y') >> integer.as(:y1) >> eol? }
  rule(:btnB) { str('Button B: X') >> integer.as(:x2) >> str(', Y') >> integer.as(:y2) >> eol? }
  rule(:prize) { str('Prize: X=') >> integer.as(:xt) >> str(', Y=') >> integer.as(:yt) >> eol? }
  rule(:machine) { btnA >> btnB >> prize }
  rule(:machines) { machine.repeat(1) }
  root(:machines)
end

input = ARGF.read
machines = Mini.new.parse_with_debug(input)

cost1 = 0
cost2 = 0

machines.each do |m|
  x1 = m[:x1].to_f
  y1 = m[:y1].to_f
  x2 = m[:x2].to_f
  y2 = m[:y2].to_f

  # Part 1
  xt = m[:xt].to_f
  yt = m[:yt].to_f
  bf = (yt/y2 - y1/y2*xt/x1)/(1 - y1/y2*x2/x1)
  af = (xt-x2*bf) / x1
  a = af.round(3)
  b = bf.round(3)
  if a.modulo(1) == 0 && b.modulo(1) == 0
    puts "a = #{a.to_i}"
    puts "b = #{b.to_i}"
    cost1 += a*3 + b
  end

  # Part 1
  xt = m[:xt].to_f + 10000000000000
  yt = m[:yt].to_f + 10000000000000
  bf = (yt/y2 - y1/y2*xt/x1)/(1 - y1/y2*x2/x1)
  af = (xt-x2*bf) / x1
  a = af.round(3)
  b = bf.round(3)
  if a.modulo(1) == 0 && b.modulo(1) == 0
    puts "a = #{a.to_i}"
    puts "b = #{b.to_i}"
    cost2 += a*3 + b
  end

end

puts cost1.to_i
puts cost2.to_i
