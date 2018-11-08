require_relative 'bro_field'
require_relative 'bro_record'

# Represents a Bro log file and provides various methods to work with it
# @todo Handle #close declaration at end of file
class BroFile

  # The number of lines at the top of a bro file that are comments
  NUMBER_OF_COMMENT_LINES = 8

  attr_reader :path, :separator, :unset_field, :open_ts, :empty_field, :set_separator, :fields

  # Creates a new BroFile
  # @param [String] path The path to the file on disk
  def initialize(path)
    raise Exception.new "Must provide a path" if path.nil?
    raise Exception.new "File not found #{path}" unless File.exists?(path)
    @path = path

    # Read the first lines to find the field names
    File.open(@path,'r').each do |line|
      break unless line[0] == '#'
      if line =~ /\#separator\s+(.*)$/
        @separator = $1
      elsif line =~ /\#set_separator\s+(.*)$/
        @set_separator = $1
      elsif line =~ /\#empty_field\s+(.*)$/
        @empty_field = $1
      elsif line =~ /\#unset_field\s+(.*)$/
        @unset_field = $1
      elsif line =~ /\#open\s+(.*)$/
        @open_ts = $1
      elsif line =~ /\#fields\s+(.*)$/
        @fields = $1.split(/\s+/)
      elsif line =~ /\#types\s+(.*)$/
        @types = $1.split(/\s+/)
      end
    end

    raise Exception.new "Didn't find fields or types" unless @fields && @types

    # Turn the fields into BroField types based on their name and data type
    fields = []
    @fields.each_with_index do |field, index|
      fields.push BroField.new(field, @types[index], index)
    end
    @fields = fields
    @file_opened = false
    @file = nil
  end

  # Retrieves a BroRecord for the given line number in a file
  # @note This can be slow for large files given that the entire file is read to get to the given line
  # @param [Integer] line_number The line number to retrieve
  # @return [BroRecord] The record associated with that line or nil if the line doesn't exist
  def get_line(line_number)
    file = File.open(@path, 'r')
    line_number += NUMBER_OF_COMMENT_LINES
    line = nil
    line_number.times{ line = file.gets }
    file.close
    if line
      BroRecord.new(@fields, line)
    else
      nil
    end
  end

  # Groups this BroFile by a given field name with the data being the timestamps in an Array
  # @param [String] field_name The field name to group by
  # @return [Hash] The grouped data, with keys being the value of the group by key and the values being an
  #   array of timestamp values
  def group_ts_by(field_name)
    grouped_data = {}
    @file = File.open(@path, 'r')
    # Skip the comments
    NUMBER_OF_COMMENT_LINES.times {@file.gets}
    line = @file.gets
    until line.nil?
      record = BroRecord.new(@fields, line)
      grouped_data[record[field_name]] ||= []
      grouped_data[record[field_name]].push(record['ts'])
      line = @file.gets
    end
    @file.close
    grouped_data
  end

  # Opens a file for sequential access to the records in the file
  # @note Will fail if the file has already been opened
  def open!
    raise Exception.new "File is already opened!" unless @file.nil?
    @file = File.open(@path, 'r')
    # Skip the comments
    NUMBER_OF_COMMENT_LINES.times {@file.gets}
    @current_line_number = 0
  end

  # Closes the currently opened file (if opened for sequential access)
  # @note Will fail if the file isn't open
  def close!
    raise Exception.new "File isn't opened" unless @file
    @file.close
    @file = nil
    @current_line_number = nil
  end

  # Retrieves the next BroRecord in the file if opened for sequential access
  # @note File must be opened!
  # @note Will return nil if there are no more lines to read
  # @return [BroRecord] The next record or nil if no more lines
  def next_record
    next_line = @file.gets
    if next_line
      @current_line_number += 1
      BroRecord.new(@fields, next_line)
    else
      nil
    end
  end

end