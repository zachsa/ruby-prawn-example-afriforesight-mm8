a = Time.now
#Sets an absolute path for wherever the program is run from
this_file = __FILE__
BASEDIR = File.expand_path(File.join(this_file, '..'))
puts "..Base Directory defined as: #{BASEDIR}"


require_relative "lib/commodity/stories.rb"
require_relative "lib/prices/prices.rb"
require_relative "lib/pdf/page.rb"
require_relative "lib/helpers.rb"
puts "..All files loaded successfully"

mm8_final_doc = find_word_file
puts "..Word doc opened successfully"

mm8_stories = StoriesJSON.new mm8_final_doc
commodity_news = mm8_stories.content
puts "..Parsed stories successfully"

prices_xlsx = find_excel_file
prices = Prices.new prices_xlsx
prices = prices.price_points
prices = PricesModule::format_for_pdf(prices)
puts "..Prices loaded successfully"



date_period = "7 DAY PERIOD OF 23 - 30 MARCH 2015"

world_growth_font_size = 8
general_stories_font_size = 7.2
content_font_size = 6.03




draw_pdf(commodity_news, prices, date_period, world_growth_font_size, general_stories_font_size, content_font_size)
puts "..PDF drawn succesfully"

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




b = Time.now


puts "Runtime: #{(b-a).round(2)} sec"