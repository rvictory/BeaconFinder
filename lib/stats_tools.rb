class StatsTools

  def self.mean(ary)
    ary.inject(:+).to_f / ary.size
  end

  def self.std_dev(ary)
    mean_value = mean(ary)
    Math.sqrt(ary.inject(0){|sum,val| sum + (val - mean_value)**2} / ary.size)
  end

end