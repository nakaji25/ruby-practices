# frozen_string_literal: true

class Game
  def initialize(pins)
    @frames = []
    generate_pins(pins)
  end

  def frame(index)
    @frames[index]
  end

  def game_score
    @frames.sum(&:frame_score)
  end

  def generate_pins(pins)
    index = 0
    frame_counter = 0
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
end
