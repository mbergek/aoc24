#!/usr/bin/env ruby

require 'parslet'
require 'parslet/convenience'

class Mini < Parslet::Parser
  rule(:cr) { match('[\n]').repeat(0) }
  rule(:eol?) { any.absent? | cr }
  rule(:space) { match('[\s]').repeat(1) }
  rule(:integer) { match('[+-]').repeat(0) >> match('[0-9]').repeat(1) }
  rule(:velocity) { str('v=') >> integer.as(:vx) >> str(',') >> integer.as(:vy) }
  rule(:position) { str('p=') >> integer.as(:x) >> str(',') >> integer.as(:y) }
  rule(:robot) { position >> space >> velocity >> eol? }
  rule(:robots) { robot.repeat(1) }
  root(:robots)
end

class Robot
  attr_accessor :x, :y, :vx, :vy, :w, :h

  def position(t)
    xp = (x+vx*t) % w
    yp = (y+vy*t) % h
    xp += w if xp<0
    yp += h if yp<0
    return [xp, yp]
  end

  def quadrant(t)
    (xf, yf) = position(t)
    (xm, ym) = [(w-1)/2, (h-1)/2]

    return 1 if xf<xm && yf<ym
    return 2 if xf>xm && yf<ym
    return 3 if xf<xm && yf>ym
    return 4 if xf>xm && yf>ym
    return 0
  end

  def initialize(x, y, vx, vy, w, h)
    @x = x
    @y = y
    @vx = vx
    @vy = vy
    @w = w
    @h = h
  end
end

input = ARGF.read
pr = Mini.new.parse_with_debug(input)

if pr.size <= 12
  (w, h) = [11, 7]
else
  (w, h) = [101, 103]
end

robots = []
pr.each do |r|
  robots << Robot.new(r[:x].to_i, r[:y].to_i, r[:vx].to_i, r[:vy].to_i, w, h)
end

q = Hash.new
q.default = 0
robots.each do |r|
  q[r.quadrant(100)] += 1
end

pp q
puts q[1] * q[2] * q[3] * q[4]

puts "Press Enter to continue"
$stdin.gets("\n")

# Part 2

require 'curses'

include Curses

init_screen
start_color

init_pair(1, 1, 0)
curs_set(0)
noecho

iteration=0

begin
  win = Curses::Window.new(h+2, w+10, 0, 0)
  loop do
    win.clear
    win.setpos(0,0)
    win.addstr("Iteration: #{iteration}")
    win.clrtoeol
    if iteration == 0
      win.setpos(1, w)
      win.addstr("w: -1")
      win.setpos(2, w)
      win.addstr("e: +1")
      win.setpos(3, w)
      win.addstr("s: -#{w}")
      win.setpos(4, w)
      win.addstr("d: +#{w}")
      win.setpos(5, w)
      win.addstr("x: -#{h}")
      win.setpos(6, w)
      win.addstr("c: +#{h}")
      win.setpos(7, w)
      win.addstr("q: quit")
      (0..h).each do |x|
        win.setpos(x+1, x)
        win.addstr((x % 10).to_s)
      end
    else
      robots.each do |r|
        (x, y) = r.position(iteration)
        win.setpos(y+1, x)
        win.addstr("█")
      end
    end

    win.refresh
    str = win.getch.to_s
    case str
    when 'w' then iteration -= 1
    when 'e' then iteration += 1
    when 's' then iteration -= w
    when 'd' then iteration += w
    when 'x' then iteration -= h
    when 'c' then iteration += h
    when 'q' then exit 0
    end
  end
ensure
  close_screen
end

