require_relative 'bro_field'
require_relative 'bro_record'

class BroFile

  # The number of lines at the top of a bro file that are comments
  NUMBER_OF_COMMENT_LINES = 8

  attr_reader :path, :separator, :unset_field, :open_ts, :empty_field, :set_separator, :fields

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

    fields = []
    @fields.each_with_index do |field, index|
      fields.push BroField.new(field, @types[index], index)
    end
    @fields = fields
  end

  def get_line(line_number)
    file = File.open(@path, 'r')
    line_number += NUMBER_OF_COMMENT_LINES
    line = nil
    line_number.times{ line = file.gets }
    if line
      BroRecord.new(@fields, line)
    else
      nil
    end
  end

  def group_ts_by(field_name)

  end

end