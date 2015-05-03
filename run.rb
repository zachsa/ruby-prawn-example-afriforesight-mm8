a = Time.now
#Sets an absolute path for wherever the program is run from
this_file = __FILE__
BASEDIR = File.expand_path(File.join(this_file, '..'))
puts "..Base Directory defined as: #{BASEDIR}"


require_relative "lib/commodity/stories.rb"
require_relative "lib/prices/prices.rb"
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





world_growth = "Stock markets were generally down last week on fears of the US Fed lifting interest rates soon, but turned upwards late Fri when the Fed chair said rate increases will be much softer than in previous cycles. Stocks were also supported by lower oil on less anxiety on the new fighting in the Middle-East.
Chinese stocks reached record highs today in Asia when the Chinese governor promised much more stimulus (some leading indicators show that China may be growing only at 3% - 4%). Mining stocks are down in Asia.
Oil calmed down over the weekend on signs that Iran may indeed make a nuclear deal with the West this week to greatly lift their oil sales. The US dollar seems ready to rebound again as it lifted slightly.
Commodities where generally down on expectations of a reviving dollar and news of low Chinese demand growth. Lower oil and lower Chinese interest rates may lead to a better week for mined commodities."



date_period = "7 DAY PERIOD OF 23 - 30 MARCH 2015"


########## General Report ##########
world_growth_font_size_general = 8
general_stories_font_size_general = 7.7
content_font_size_general = 7.91


########## ENERGY ##########
world_growth_font_size_energy = 13.3
general_stories_font_size_energy = 12.2
content_font_size_energy = 11.9


########## PLATINUM ##########
world_growth_font_size_platinum = 13
general_stories_font_size_platinum = 12
content_font_size_platinum = 11.6





Report::GeneralReport.new(world_growth, commodity_news, prices, date_period, world_growth_font_size_general, general_stories_font_size_general, content_font_size_general)

Report::EnergyReport.new(world_growth, commodity_news, prices, date_period, world_growth_font_size_energy, general_stories_font_size_energy, content_font_size_energy)

Report::PlatinumReport.new(world_growth, commodity_news, prices, date_period, world_growth_font_size_platinum, general_stories_font_size_platinum, content_font_size_platinum)



db_connection = DB.new('localhost', 'root', 'pfnafn1', 'afriforesightresearch', commodity_news_db)
db_connection.add_to_mysql_db


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