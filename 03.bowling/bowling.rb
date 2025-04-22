#!/usr/bin/env ruby
# frozen_string_literal: true

FRAMES = 10 # 1ゲームのフレーム数

def data_input
  score = ARGV[0]
  scores = score.split(',')
  shots = []
  scores.each do |s|
    if s == 'X' # strike
      shots << 10
      shots << 0
    else
      shots << s.to_i
    end
  end
  shots.each_slice(2).to_a
end

def game_point(frames)
  point = 0
  (0..FRAMES - 1).each do |frame|
    point +=
      if frames[frame][0] == 10 # strike
        if frames[frame + 1][0] != 10
          10 + frames[frame + 1].sum
        else
          10 + frames[frame + 1].sum + frames[frame + 2][0] # 2連続ストライクの場合次の1投目も加算
        end
      elsif frames[frame].sum == 10 # spare
        10 + frames[frame + 1][0]
      else
        frames[frame].sum
      end
  end
  puts point
end

frames = data_input
game_point(frames)
