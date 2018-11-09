require_relative 'stats_tools'

class BeaconFinder

  def self.find_beacons(data)
    results = []
    data.each do |key, value|
      # First sort the timestamps
      value = value.sort
      # Next, find the array that is the difference between each timestamp, right to left
      difference_array = []
      reversed_values = value.reverse
      reversed_values.each_with_index do |ts, i|
        unless i == reversed_values.length - 1
          difference_array.push(ts - reversed_values[i + 1])
        end
      end
      # Next, we need to remove any outliers
      # Next, find the standard deviation of the difference array
      standard_dev = StatsTools.std_dev(difference_array)
      # Finally, find the mean interval
      mean_interval = StatsTools.mean(difference_array)
      results.push(BeaconResult.new(key, value, difference_array, standard_dev, mean_interval))
    end
    results
  end

end

class BeaconResult

  attr_reader :ts_array, :key, :difference_array, :mean_interval, :standard_deviation

  def initialize(key, ts_array, difference_array, standard_deviation, mean_interval)
    @key = key
    @ts_array = ts_array
    @difference_array = difference_array
    @standard_deviation = standard_deviation
    @mean_interval = mean_interval
  end

  def to_hash
    {
        :key => @key,
        :ts_array => @ts_array,
        :difference_array => @difference_array,
        :standard_deviation => @standard_deviation,
        :mean_interval => @mean_interval
    }
  end

end