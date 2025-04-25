#!/usr/bin/env ruby
# frozen_string_literal: true

FRAMES = 10

def generate_pins
  frames_text = ARGV[0]
  frames = frames_text.split(',')
  pins = []
  frames.each do |frame|
    if frame == 'X'
      pins << 10
      pins << 0
    else
      pins << frame.to_i
    end
  end
  pins.each_slice(2).to_a
end

def sum_pins(pins)
  FRAMES.times.sum do |i|
    if pins[i][0] == 10
      if pins[i + 1][0] != 10
        10 + pins[i + 1].sum
      else
        10 + pins[i + 1].sum + pins[i + 2][0]
      end
    elsif pins[i].sum == 10
      10 + pins[i + 1][0]
    else
      pins[i].sum
    end
  end
end

pins = generate_pins
puts sum_pins(pins)
