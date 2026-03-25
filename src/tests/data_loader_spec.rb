# frozen_string_literal: true
require_relative '../main/data_loader'

describe 'Data Loader' do
  let(:data_loader) { DataLoader.new }

  it 'returns array of Hash objects when loading data from a board file' do
    data = data_loader.load_data_from('../data/board.json')
    expect(data).to be_an(Array)
    expect(data.first).to be_a(Hash)
  end

  it 'returns array of Hash objects when loading players from a valid JSON file' do
    data = data_loader.load_data_from('../data/players.json')
    expect(data).to be_an(Array)
    expect(data.first).to be_a(Hash)
  end

  it 'returns array of integers when loading dice rolls from a valid JSON file' do
    data = data_loader.load_data_from('../data/rolls_1.json')
    expect(data).to be_an(Array)
    expect(data.first).to be_an(Integer)
  end

  it 'raises error when loading data from an invalid JSON file' do
    expect { data_loader.load_data_from('../data/non_existent_file.json') }.to raise_error(Errno::ENOENT)
  end
end