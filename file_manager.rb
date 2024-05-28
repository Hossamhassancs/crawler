class FileManager

  attr_reader :file_name

  def initialize(file_name)
    @file_name = file_name
  end

  def read_file
    begin
      File.readlines(self.file_name).map(&:chomp)
    rescue => e
      puts "Error reading file #{self.file_name}: #{e.message}"
      []
    end
  end

  def write_file
    File.write('done.txt', 'done')
  end
end