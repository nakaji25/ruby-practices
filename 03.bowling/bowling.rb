#!/usr/bin/env ruby
# frozen_string_literal: true

FRAMES = 10

def generate_frames
  pins_text = ARGV[0]
  pins = pins_text.split(',')
  frames = []
  pins.each do |pin|
    if pin == 'X'
      frames << 10
      frames << 0
    else
      frames << pin.to_i
    end
  end
  frames.each_slice(2).to_a
end

def sum_score(frames)
  FRAMES.times.sum do |i|
    if frames[i][0] == 10
      if frames[i + 1][0] != 10
        10 + frames[i + 1].sum
      else
        10 + frames[i + 1].sum + frames[i + 2][0]
      end
    elsif frames[i].sum == 10
      10 + frames[i + 1][0]
    else
      frames[i].sum
    end
  end
end

frames = generate_frames
puts sum_score(frames)
