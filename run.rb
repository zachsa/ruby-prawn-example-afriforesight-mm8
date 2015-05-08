a = Time.now
#Sets an absolute path for wherever the program is run from
this_file = __FILE__
BASEDIR = File.expand_path(File.join(this_file, '..'))
puts "..Base Directory defined as: #{BASEDIR}"

require 'ap'
require_relative "lib/commodity/stories.rb"
require_relative "lib/prices/prices.rb"
require_relative 'lib/worldgrowth/worldgrowth.rb'
require_relative "lib/report/mm8.rb"
require_relative "lib/helpers.rb"
require_relative "lib/db/db_api.rb"
puts "..All files loaded successfully"

mm8_final_doc = find_word_file
puts "..Word doc opened successfully"


mm8_stories = StoriesJSON.new mm8_final_doc
commodity_news = mm8_stories.content
commodity_news_db = mm8_stories.content_for_db
puts "..Parsed stories successfully"

#prices_input = :auto
prices_input = :manual #Enter the prices directly into the Prices file.

if prices_input == :auto
	begin
		prices_xlsx = find_excel_file
	rescue
		puts "ERROR"
		puts "Cannot locate Excel fiel"
		exit
	end

	begin
		prices = Prices.new prices_xlsx
		prices = prices.price_points
	rescue
		puts "ERROR"
		puts "Cannot automatically generate price points. Try entering them manually instead."
		exit
	end
elsif prices_input == :manual
	begin	
		prices = price_points_manual
	rescue
		puts "ERROR"
		puts "Problem using manual price points, check syntax"
	end
end


#Put a word doc in /lib/worldgrowth
  #NO HEADING
  #PARAGRAPHS SEPERATED 
  
world_growth = WorldGrowth.new
world_growth = world_growth.content



date_period = "14 DAY PERIOD OF 20 April - 4 MARCH 2015"


########## General Report ##########
world_growth_font_size_general = 7.5
general_stories_font_size_general = 8.265
content_font_size_general = 5.33


########## ENERGY ##########
world_growth_font_size_energy = 11.7
general_stories_font_size_energy = 12.9
content_font_size_energy = 8.1


########## PLATINUM ##########
world_growth_font_size_platinum = 11.3
general_stories_font_size_platinum = 12.35
content_font_size_platinum = 8.6





Report::GeneralReport.new(world_growth, commodity_news, prices, date_period, world_growth_font_size_general, general_stories_font_size_general, content_font_size_general)
Report::EnergyReport.new(world_growth, commodity_news, prices, date_period, world_growth_font_size_energy, general_stories_font_size_energy, content_font_size_energy)
Report::PlatinumReport.new(world_growth, commodity_news, prices, date_period, world_growth_font_size_platinum, general_stories_font_size_platinum, content_font_size_platinum)


puts "..Initializing database"
db_connection = DB.new('localhost', 'root', 'pfnafn1', 'afriforesightresearch', commodity_news_db)
puts "..Inserting into database"
db_connection.add_to_mysql_db
puts "Done"

b = Time.now


puts "Program complete."
puts "Runtime: #{(b-a).round(2)} sec"
exit



#List of the delimeters that must be used in the word doc
#The order of the stories is very important
=begin
delimeters = {
	GENERAL_STORIES
	IRON_STORIES
	MANGANESE_STORIES
	CHROME_STORIES
	GOLD_STORIES
	PGM_STORIES
	DIAMONDS_STORIES
	COPPER_STORIES
	ALUMINIUM_STORIES
	NICKEL_STORIES
	COAL_STORIES
	OIL_GAS_STORIES
	URANIUM_STORIES
}
=end