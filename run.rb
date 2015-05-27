a = Time.now

#Sets an absolute path for wherever the program is run from
#this_file = __FILE__
#BASEDIR = File.expand_path(File.join(this_file, '..'))
this_file = __FILE__
this_file_folder_nav = File.join(this_file, '..')
BASEDIR = File.expand_path(this_file_folder_nav)


#Required Gems
require 'ap'
require 'docx'
require 'sanitize'
require 'Mysql2'
require 'os'
require 'win32ole' if OS.windows?
require 'date'
require 'roo'
require 'prawn'

#Docx Parsing Modules
require_relative "lib/commodity/stories.rb"
require_relative 'lib/worldgrowth/worldgrowth.rb'

#Prices Module
require_relative "lib/prices/prices.rb"
require_relative 'lib/prices/prices_module.rb'

#Database Module
require_relative "lib/db/db_api.rb"

#Report Generator Module
require_relative 'lib/prawn/base.rb'
require_relative 'lib/prawn/general_mining_report.rb'
require_relative 'lib/prawn/energy_report.rb'
require_relative 'lib/prawn/platinum_report.rb'




mm8_stories = StoriesJSON.new
commodity_news = mm8_stories.content
commodity_news_db = mm8_stories.content_for_db

world_growth = WorldGrowth.new #Put a word doc in /lib/worldgrowth, NO HEADING, PARAGRAPHS SEPERATED
world_growth = world_growth.content

#prices_input = :auto
prices_input = :manual
prices = Prices.new(prices_input)
prices = prices.price_points



# USER INPUT DATA

date_period = "7 DAY PERIOD OF 18 - 25 May 2015"


########## GENERAL Report ##########
world_growth_font_size_general = 8.7
general_stories_font_size_general = 8
content_font_size_general = 6.25


########## ENERGY ##########
world_growth_font_size_energy = 14.7
general_stories_font_size_energy = 13.2
content_font_size_energy = 8.89


########## PLATINUM ##########
world_growth_font_size_platinum = 14
general_stories_font_size_platinum = 12.5
content_font_size_platinum = 9.9



#Report::GeneralReport.new(world_growth, commodity_news, prices, date_period, world_growth_font_size_general, general_stories_font_size_general, content_font_size_general)
#Report::EnergyReport.new(world_growth, commodity_news, prices, date_period, world_growth_font_size_energy, general_stories_font_size_energy, content_font_size_energy)
#Report::PlatinumReport.new(world_growth, commodity_news, prices, date_period, world_growth_font_size_platinum, general_stories_font_size_platinum, content_font_size_platinum)


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