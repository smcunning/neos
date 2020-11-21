require_relative 'near_earth_objects'
require 'pry'

class NeoTable
  def initialize
    @date = ""
  end

  def start
    find_date
    closing_message
  end

  def welcome_message
    puts "________________________________________________________________________________________________________________________________"
    puts "Welcome to NEO. Here you will find information about how many meteors, astroids, comets pass by the earth every day. \nEnter a date below to get a list of the objects that have passed by the earth on that day."
    puts "Please enter a date in the following format YYYY-MM-DD."
    print ">>"
  end

  def closing_message
    puts "______________________________________________________________________________"
    puts "On #{formatted_date}, there were #{total_number_of_astroids} objects that almost collided with the earth."
    puts "The largest of these was #{largest_asteroid} ft. in diameter."
    puts "\nHere is a list of objects with details:"
    puts divider
    puts header
    create_rows(asteroid_list, column_data)
    puts divider
  end

  def find_date
    welcome_message
    @date = gets.chomp
  end

  def formatted_date
    DateTime.parse(@date).strftime("%A %b %d, %Y")
  end

  def asteroid_data
    neos = NearEarthObjects.new(@date)
    neos.find_neos_by_date
  end

  def asteroid_list
    asteroid_data[:astroid_list]
  end

  def total_number_of_astroids
    asteroid_data[:total_number_of_astroids]
  end

  def largest_asteroid
    asteroid_data[:biggest_astroid]
  end

  def column_data
    column_labels = { name: "Name", diameter: "Diameter", miss_distance: "Missed The Earth By:" }
    column_labels.each_with_object({}) do |(col, label), hash|
      hash[col] = {
        label: label,
        width: [asteroid_list.map { |astroid| astroid[col].size }.max, label.size].max}
    end
  end

  def header
    "| #{ column_data.map { |_,col| col[:label].ljust(col[:width]) }.join(' | ') } |"
  end

  def divider
    "+-#{column_data.map { |_,col| "-"*col[:width] }.join('-+-') }-+"
  end

  def format_row_data(row_data, column_info)
    row = row_data.keys.map { |key| row_data[key].ljust(column_info[key][:width]) }.join(' | ')
    puts "| #{row} |"
  end

  def create_rows(astroid_data, column_info)
    rows = astroid_data.each { |astroid| format_row_data(astroid, column_info) }
  end
end
