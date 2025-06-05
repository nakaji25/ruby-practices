# frozen_string_literal: true

# !/usr/bin/env ruby

require_relative 'game'
require_relative 'frame'
require_relative 'shot'

def main
  pins_text = ARGV[0]
  pins = pins_text.split(',')
  game = Game.new(pins)
  puts game.game_score
end

main
