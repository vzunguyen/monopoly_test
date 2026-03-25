# frozen_string_literal: true
require_relative '../main/cli_parser'
describe 'CLI Parser' do
  let(:cli_parser) { CLIParser.new }

  describe '#parse' do
    it 'parses dice rolls file path' do
      cli_parser.parse(%w[-d ../data/rolls_1.json])
      expect(cli_parser.dice_rolls_file_path).to eq('../data/rolls_1.json')
    end

    it 'parses players file path' do
      cli_parser.parse(%w[-p ../data/players.json])
      expect(cli_parser.players_file_path).to eq('../data/players.json')
    end

    it 'parses board file path' do
      cli_parser.parse(%w[-b ../data/board.json])
      expect(cli_parser.board_file_path).to eq('../data/board.json')
    end
  end
end

