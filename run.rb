#Sets an absolute path for wherever the program is run from
this_file = __FILE__
BASEDIR = File.expand_path(File.join(this_file, '..'))
puts "..Base Directory defined as: #{BASEDIR}"


require_relative "lib/commodity/stories.rb"
require_relative "lib/prices/prices.rb"
require_relative "lib/pdf/page.rb"
require_relative "lib/helpers.rb"


mm8_final_doc = find_word_file
mm8_stories = StoriesJSON.new mm8_final_doc
commodity_news = mm8_stories.content

prices_xlsx = find_excel_file
prices = Prices.new prices_xlsx
prices = prices.price_points
prices = PricesModule::format_for_pdf(prices)



date_period = "7 DAY PERIOD OF 23 - 30 MARCH 2015"

world_growth_font_size = 0
general_stories_font_size = 7.8
content_font_size = 7.9




draw_pdf(commodity_news, prices, date_period, world_growth_font_size, general_stories_font_size, content_font_size)

