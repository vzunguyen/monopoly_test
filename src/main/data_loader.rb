# frozen_string_literal: true
require 'json'
class DataLoader

  def load_data_from(file_path)
    file_path = File.expand_path(file_path, __dir__)
    data = JSON.parse(File.read(file_path))
    raise "ERROR: Failed to load data from #{file_path}" if data.nil?

    puts "DATA: Loaded data from #{file_path}"
    data
  end
end

