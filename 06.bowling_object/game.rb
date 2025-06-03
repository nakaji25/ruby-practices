# frozen_string_literal: true

class Game
  attr_reader :frames

  def initialize(*pins_array)
    index = 0
    frame_counter = 0
    @frames = []
    pins = pins_array[0]
    while index <= pins.length
      if frame_counter == 9
        @frames << Frame.new(self, frame_counter, pins[index], pins[index + 1], pins[index + 2])
        frame_counter += 1
        index += 3
      elsif pins[index] == 'X'
        @frames << Frame.new(self, frame_counter, pins[index], nil)
        frame_counter += 1
        index += 1
      else
        @frames << Frame.new(self, frame_counter, pins[index], pins[index + 1])
        frame_counter += 1
        index += 2
      end
    end
  end

  def frame(index)
    @frames[index]
  end

  def game_score
    score = 0
    frames.each do |frame|
      score += frame.frame_score
    end
    score
  end
end
