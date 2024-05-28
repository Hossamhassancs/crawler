require 'net/http'
require 'uri'
require 'parallel'
require 'redis'
require_relative 'file_manager'
require_relative 'scrapper'
require_relative 'redis_fetcher'
require_relative 'csv_exporter'

file_names = { urls_file: 'urls-dev-test.txt' ,keywords_file: 'keywords-dev-test.txt'}
base_url = ENV['base_url']
api_token = ENV['api_token']

file_readers = file_names.values.map { |file_name| FileManager.new(file_name) }

file_contents = Parallel.map(file_readers, in_threads: 5) do |file_reader|
    file_reader.read_file
end

file_results = file_names.keys.zip(file_contents).to_h
urls = file_results[:urls_file]
scrapper = Scrapper.new(urls, api_token, base_url)
scrapper.scrape_and_save

keywords = file_results[:keywords_file]

fetcher = RedisFetcher.new
parsed_data = fetcher.fetch_data

rows = []

parsed_data.each do |url, sentences|
  sentences.each do |sentence|
    keywords.each do |keyword|
      rows << [url, keyword, sentence] if sentence.include?(keyword)
    end
  end
end

CsvExporter.new('example-output-dev-test.csv', rows).write_to_csv

FileManager.new('done.txt').write_file
puts "CSV file 'example-output-dev-test.csv' has been created successfully."
