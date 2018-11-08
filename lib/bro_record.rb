class BroRecord

  # @param fields [Array] The fields to use for this record
  def initialize(fields, line, separator="\t")
    line.split(separator).each_with_index do |record, index|
      fields[index].data = record
    end
    @fields = fields
  end

  def [](value)
    if value.is_a?(Numeric)
      @fields[value]
    else
      @fields.select {|x| x.name == value.to_s}
    end
  end

end