#!/usr/bin/env ruby

require 'parslet'
require 'parslet/convenience'

# Example code
#
# Register A: 729
# Register B: 0
# Register C: 0
# 
# Program: 0,1,5,4,3,0
#
# Literal operands (op): 0-7
# Combo operands (cop):
# 0-3 = literal values 0-3
# 4 = value of register A
# 5 = value of register B
# 6 = value of register C
# 7 = reserved (will not appear in valid program)

# Opcodes:
# 0: adv cop (division by 2^cop -> truncated -> A)
# 1: bxl op (bitwise XOR -> B)
# 2: bst cop (modulo 8 -> B)
# 3: jnz op (jumps if A is non-zero)
# 4: bxc op (bitwise XOR of B & C -> B, operand is ignored)
# 5: out cop (outputs combo operand modulo 8)
# 6: bdv cop (divides A by 2^cop -> B)
# 7: cdv cop (divides A by 2^cop -> C)


class Mini < Parslet::Parser
  rule(:cr) { match('[\n]').repeat(0) }
  rule(:eol?) { any.absent? | cr }
  rule(:comma?) { str(',') | any.absent? }
  rule(:integer) { match('[+-]').repeat(0) >> match('[0-9]').repeat(1) }
  rule(:regA) { str('Register A: ') >> integer.as(:a) >> eol? }
  rule(:regB) { str('Register B: ') >> integer.as(:b) >> eol? }
  rule(:regC) { str('Register C: ') >> integer.as(:c) >> eol? }
  rule(:op) { integer.as(:op) >> comma? }
  rule(:ops) { op.repeat(0) }
  rule(:prog) { str('Program: ') >> ops.as(:ops) >> eol? }
  rule(:program) { regA >> regB >> regC >> prog }
  root(:program)
end

def cop(op)
  case op
  when 0..3
    return op
  when 4
    return $a
  when 5
    return $b
  when 6
    return $c
  else 7
    raise "Error"
  end
end



def run(a, b, c, input)

  $a = a
  $b = b
  $c = c

  ip = 0
  run = true
  out = []
  verbose = false
  
  while run
  
    operator = $ops[ip]
    operand = $ops[ip+1]
  
    case operator
    when 0
      # 0: adv cop (division by 2^cop -> truncated -> A)
      puts "adv" if verbose
      $a = ($a.to_f / 2**cop(operand)).floor.to_i
      output_state(out, ip) if verbose
    when 1
      # 1: bxl op (bitwise XOR -> B)
      puts "bxl" if verbose
      $b = $b ^operand
      output_state(out, ip) if verbose
    when 2
      # 2: bst cop (modulo 8 -> B)
      puts "bst" if verbose
      $b = cop(operand) % 8
      output_state(out, ip) if verbose
    when 3
      # 3: jnz op (jumps if A is non-zero)
      puts "jnz" if verbose
      if $a != 0
        ip = operand - 2
      end
      output_state(out, ip) if verbose
    when 4
      # 4: bxc op (bitwise XOR of B & C -> B, operand is ignored)
      puts "bxc" if verbose
      $b = $b ^ $c
      output_state(out, ip) if verbose
    when 5
      # 5: out cop (outputs combo operand modulo 8)
      puts "out" if verbose
      out << cop(operand) % 8
      output_state(out, ip) if verbose
    when 6
      # 6: bdv cop (divides A by 2^cop -> B)
      puts "bdv" if verbose
      $b = ($a.to_f / 2**cop(operand)).floor.to_i
      output_state(out, ip) if verbose
    when 7
      # 7: cdv cop (divides A by 2^cop -> C)  
      puts "cdv" if verbose
      $c = ($a.to_f / 2**cop(operand)).floor.to_i
      output_state(out, ip) if verbose
    else
      puts "NOP"
    end

    ip += 2

    unless ip.between?(0, $ops.size - 1)
      run = false
    end
  end
  
  return out

end


input = ARGF.read
p = Mini.new.parse_with_debug(input)

a0 = p[:a].to_i
b0 = p[:b].to_i
c0 = p[:c].to_i
$ops = p[:ops].map { |c| c[:op].to_i }

puts "Registers: #{a0} #{b0} #{c0}"
puts "Commands : #{$ops}"

puts "Part 1:"
puts run(a0, b0, c0, $ops).join(',')


# Part 2

puts
puts "Part 2:"

o = []
found = 0
a = 1

while o != $ops
  a += 1  
  o = run(a, b0, c0, $ops)

  if o == $ops
    puts "#{a}: #{o.join(',')}"
    break
  end

  if o.last(found + 1) == $ops.last(found + 1)
    found += 1
    puts "#{a}: #{o.join(',')}"
    a = a * 8 - 8
  end  
end
  
