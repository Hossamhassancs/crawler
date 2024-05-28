require 'csv'

class CsvExporter
  attr_reader :csv_file, :rows

  def initialize(csv_file = 'example-output-dev-test.csv', rows = [])
    @csv_file = csv_file
    @rows = rows
  end

  def write_to_csv
    CSV.open(csv_file, 'w') do |csv|
      # Write the header
      csv << ['URL', 'Keyword', 'Sentence']
      # Write the data
      rows.each do |row|
        csv << row
      end
    end
    puts "CSV file '#{csv_file}' has been created successfully."
  end
end
