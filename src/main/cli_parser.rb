# frozen_string_literal: true
require 'optparse'
class CLIParser
  attr_reader :dice_rolls_file_path, :board_file_path, :players_file_path
  def parse(args)
    opts = OptionParser.new do |opts|
      opts.banner = "Usage: ruby src/main/main.rb [options]"

      opts.on("-d", "--dice-rolls FILE", "Path to dice rolls file") do |file_path|
        @dice_rolls_file_path = file_path
      end

      opts.on("-b", "--board FILE", "Path to board file") do |file_path|
        @board_file_path = file_path
      end

      opts.on("-p", "--players FILE", "Path to players file") do |file_path|
        @players_file_path = file_path
      end

      opts.on("-h", "--help", "Prints this help") do
        puts opts
        exit
      end
    end

    opts.parse!(args)
    self
  end
end
