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

prices_input = :auto
#prices_input = :manual

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


prices = PricesModule::format_for_pdf(prices)
puts "..Prices loaded successfully"











world_growth = "Stock markets were generally down last week on fears of the US Fed lifting interest rates soon, but turned upwards late Fri when the Fed chair said rate increases will be much softer than in previous cycles. Stocks were also supported by lower oil on less anxiety on the new fighting in the Middle-East.
Chinese stocks reached record highs today in Asia when the Chinese governor promised much more stimulus (some leading indicators show that China may be growing only at 3% - 4%). Mining stocks are down in Asia.
Oil calmed down over the weekend on signs that Iran may indeed make a nuclear deal with the West this week to greatly lift their oil sales. The US dollar seems ready to rebound again as it lifted slightly.
Commodities where generally down on expectations of a reviving dollar and news of low Chinese demand growth. Lower oil and lower Chinese interest rates may lead to a better week for mined commodities."



date_period = "7 DAY PERIOD OF 23 - 30 MARCH 2015"

world_growth_font_size = 8.2
general_stories_font_size = 7.2
content_font_size = 6.03









draw_pdf(world_growth, commodity_news, prices, date_period, world_growth_font_size, general_stories_font_size, content_font_size)
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