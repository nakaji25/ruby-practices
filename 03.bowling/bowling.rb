#!/usr/bin/env ruby
# frozen_string_literal: true

FRAMES = 10

def gets_score
  scores_text = ARGV[0]
  scores = scores_text.split(',')
  shots = []
  scores.each do |score|
    if score == 'X'
      shots << 10
      shots << 0
    else
      shots << score.to_i
    end
  end
  shots.each_slice(2).to_a
end

def sum_points(scores)
  point = 0
  FRAMES.sum do |i|
    point +=
      if scores[i][0] == 10
        if scores[i + 1][0] != 10
          10 + scores[i + 1].sum
        else
          10 + scores[i + 1].sum + scores[i + 2][0]
        end
      elsif scores[i].sum == 10
        10 + scores[i + 1][0]
      else
        scores[i].sum
      end
  end
  puts point
end

scores = gets_score
sum_points(scores)
