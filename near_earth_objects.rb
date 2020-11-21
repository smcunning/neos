require 'faraday'
require 'figaro'
require 'pry'
# Load ENV vars via Figaro
Figaro.application = Figaro::Application.new(environment: 'production', path: File.expand_path('../config/application.yml', __FILE__))
Figaro.load

class NearEarthObjects
  def initialize(date)
    @date = date
    @asteroids_data = parsed_asteroids_data
  end

  def parsed_asteroids_data
    asteroids_list_data = connect.get('/neo/rest/v1/feed')
    JSON.parse(asteroids_list_data.body, symbolize_names: true)[:near_earth_objects][:"#{@date}"]
  end

  def connect
    Faraday.new(
        url: 'https://api.nasa.gov',
        params: { start_date: @date, api_key: ENV['nasa_api_key']}
      )
  end

  def find_neos_by_date
    {
      astroid_list: format_asteroid_data,
      biggest_astroid: get_diameter(largest_asteroid),
      total_number_of_asteroids: total_number_of_asteroids
    }
  end

  def format_asteroid_data
    @asteroids_data.map do |asteroid|
      {
        name: asteroid[:name],
        diameter: "#{get_diameter(asteroid)} ft",
        miss_distance: "#{get_miss_distance(asteroid)} miles"
      }
    end
  end

  def get_diameter(asteroid)
    asteroid[:estimated_diameter][:feet][:estimated_diameter_max].to_i
  end

  def largest_asteroid
    @asteroids_data.max do |asteroid_a, asteroid_b|
      get_diameter(asteroid_a) <=> get_diameter(asteroid_b)
    end
  end

  def get_miss_distance(asteroid)
    asteroid[:close_approach_data][0][:miss_distance][:miles].to_i
  end

  def total_number_of_asteroids
    @asteroids_data.count
  end
end
