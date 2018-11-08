class BroField

  attr_accessor :name, :index, :type, :data

  def initialize(name, type, index, data=nil)
    @name = name
    @type = type
    @index = index
    @data = data
  end

end