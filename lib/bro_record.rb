# Holds a Bro record (line) from a Bro log file. Provides a way to extract fields by index or name
class BroRecord

  # Creates a new instance of a BroRecord
  # @param [Array] fields The fields to use for this record
  # @param [String] line The line that is to be parsed
  # @param [String] separator The separator used for this line
  # @return [BroRecord] The new record
  def initialize(fields, line, separator="\t")
    line.split(separator).each_with_index do |record, index|
      fields[index].data = record
    end
    @fields = fields
  end

  # Retrieves a field by index or by name
  # @param [String|Integer] The field index as an integer or the String name of the field
  # @return [String] The value of that field or nil if it doesn't exist
  def [](value)
    if value.is_a?(Integer)
      @fields[value]
    else
      @fields.select {|x| x.name == value.to_s}
    end
  end

end