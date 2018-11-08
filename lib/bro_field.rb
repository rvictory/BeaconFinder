# Represents a field in a Bro file with an optional value
class BroField

  attr_accessor :name, :index, :type, :data

  # Creates a new BroField
  # @param [String] name The name of the field
  # @param [String] type The type of the field
  # @param [Integer] index The index (offset) for this field in the Bro record
  # @param [String] data The data that this field contains
  # @return [BroField] The new object
  def initialize(name, type, index, data=nil)
    @name = name
    @type = type
    @index = index
    @data = data
  end

end