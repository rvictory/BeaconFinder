require 'json'
require 'minitest'
require 'minitest/autorun'

require 'minitest/reporters'

MiniTest::Reporters.use!

require_relative '../lib/beacon_finder'

class TestBeaconFinder < MiniTest::Test

  # @todo Make this actually test something
  def test_find_beacons
    data = {
        :key1 => [1, 6, 11, 16, 22, 27],
        :key2 => [1, 11, 13, 25, 100, 234]
    }
    results = BeaconFinder.find_beacons(data)
    results = results.map(&:to_hash)
    puts JSON.pretty_unparse(results)
  end

end