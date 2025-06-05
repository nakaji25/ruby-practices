# frozen_string_literal: true

class Frame
  attr_reader :first_shot, :second_shot, :third_shot, :frame_index, :game

  def initialize(game, frame_index, first_pin, second_pin, third_pin = nil)
    @frame_index = frame_index
    @first_shot = Shot.new(first_pin)
    @second_shot = Shot.new(second_pin)
    @third_shot = Shot.new(third_pin)
    @game = game
  end

  def next_frame
    game.frame(frame_index + 1)
  end

  def nextnext_frame
    game.frame(frame_index + 2)
  end

  def frame_score
    if frame_index == 9
      [first_shot.score, second_shot.score, third_shot.score].sum
    elsif first_shot.score == 10
      if next_frame.first_shot.score != 10 || frame_index == 8
        10 + [next_frame.first_shot.score, next_frame.second_shot.score].sum
      else
        10 + [next_frame.first_shot.score, nextnext_frame.first_shot.score].sum
      end
    elsif first_shot.score + second_shot.score == 10
      10 + next_frame.first_shot.score
    else
      [first_shot.score, second_shot.score].sum
    end
  end
end
