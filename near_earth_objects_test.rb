require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require_relative 'near_earth_objects'

class NearEarthObjectsTest < Minitest::Test
  def test_a_date_returns_a_list_of_neos
    neo = NearEarthObjects.new('2019-03-31')
    results = neo.find_neos_by_date
  
    assert_equal '163081 (2002 AG29)', results[:astroid_list][0][:name]
  end
end
