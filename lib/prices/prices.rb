require 'date'
require 'roo'

require_relative 'prices_module.rb'



def price_points_manual
	price_points = {

		:baltic => "hasdf",
		:iron_ore => "asD",
		:manganese => "asd",
		:chrome => "",
		:gold => "",
		:platinum => "",
		:palladium => "",
		:diamonds => "",
		:copper => "",
		:nickel => "",
		:aluminium => "",
		:coal => "",
		:oil => "",
		:gas => "",
		:uranium => ""
	}
end





class Prices
	attr_accessor :price_points, :mon_new
	
	
		
	def initialize(filename)
		
		begin
			file = Roo::Excelx.new(filename)
		rescue
			puts "Could not locate an Excel Spreadsheet"
			exit
		end
		
		mon_new = Date.strptime(file.cell('G', 1))
		mon_old = Date.strptime(file.cell('D', 1))
		mon_new = PricesModule::convert_date(mon_new)
		mon_old = PricesModule::convert_date(mon_old)
		
		@mon_new = mon_new

		fri_new = Date.strptime(file.cell('E', 1))
		fri_old = Date.strptime(file.cell('C', 1))
		fri_new = PricesModule::convert_date(fri_new)
		fri_old = PricesModule::convert_date(fri_old)
		
		
		
		prices = PricesModule::get_prices(file)
		
		
		
		#Add % change and change to hash
		prices.each do |comm, arr|
			a = prices[comm][:new].to_f
			b = prices[comm][:old].to_f
			change_percent = ((a/b)-1)*100
			prices[comm][:change_percent] = change_percent.round(1)
		end
		
		
		
		#Checks that the rounding of prices and %s doesn't leave trailing zeros
		prices.clone.each do |comm,arr|
			prices[comm].clone.each do |date, num|
				prices[comm][date] = PricesModule::check_rounding(num)
			end
		end
		
		
		#Add trend to the hash
		prices.each do |comm, arr|
			a = prices[comm][:new].to_f
			b = prices[comm][:old].to_f
			change_per = ((a/b)-1)*100
	
			direction = PricesModule::price_direction(change_per)
			trend = "#{direction}"
	
			prices[comm][:trend] = trend
		end
		
		
		#Separates thousands for the prices
		prices.clone.each do |comm, arr|
			a = PricesModule::separate(prices[comm][:new])
			b = PricesModule::separate(prices[comm][:old])
	
			prices[comm][:new] = a
			prices[comm][:old] = b
		end

		prices[:manganese][:tonne] = PricesModule::latest_price_tonne(prices[:manganese][:new])
		
		
		
		
		#Bulk Cargo and Shipping

		baltic = "BALTIC DRY - #{prices[:baltic_dry][:trend].downcase.capitalize} on Friday from previous Friday. Capesize rates #{prices[:baltic_dry_cape][:trend].downcase}."


		#Bulk Metals

		iron_ore = "IRON ORE #{fri_new[:full]} Qingdao, China close: $#{PricesModule::check_rounding(prices[:iron_ore][:new].to_f.round(1))}/t #{prices[:iron_ore][:trend]} from #{fri_old[:full]} close"
		manganese_ore = "MANGANESE #{fri_new[:full]} close: $#{PricesModule::check_rounding(prices[:manganese][:new].to_f.round(2))}/dmtu ($#{prices[:manganese][:tonne]}/t) #{prices[:manganese][:trend]} from #{fri_old[:full]} close"
		chrome_ore = "CHROME ORE #{fri_new[:full]} South Africa close: $#{PricesModule::check_rounding(prices[:chrome][:new].to_f.round(1))}/t #{prices[:chrome][:trend]} from #{fri_old[:full]} close"

		#Precious Metals
		gold = "GOLD Today’s afternoon price in Asia: $#{prices[:gold][:new]}/oz #{prices[:gold][:trend]} from #{mon_old[:day]} morning #{mon_old[:num_month]}"
		platinum = "PLATINUM Today’s afternoon price in Asia: $#{prices[:platinum][:new]}/oz #{prices[:platinum][:trend]} from #{mon_old[:day]} morning #{mon_old[:num_month]}"
		palladium = "PALLADIUM Today’s afternoon price in Asia: $#{prices[:palladium][:new].to_f.round(0)}/oz #{prices[:palladium][:trend]} from #{mon_old[:day]} morning #{mon_old[:num_month]}"
		diamonds = "DIAMONDS Overall polished price index #{fri_new[:full]} close: #{PricesModule::check_rounding(prices[:diamonds][:new].to_f.round(0))} #{prices[:diamonds][:trend]} from #{fri_old[:full]} close"



		#Base Metals
		aluminium = "ALUMINIUM Today’s afternoon price in Asia: $#{prices[:aluminium][:new]}/t #{prices[:aluminium][:trend]} from #{mon_old[:day]} morning #{mon_old[:num_month]}"
		copper = "COPPER Today’s afternoon price in Asia: $#{prices[:copper][:new]}/t #{prices[:copper][:trend]} from #{mon_old[:day]} morning #{mon_old[:num_month]}"
		nickel = "NICKEL Today’s afternoon price in Asia: $#{prices[:nickel][:new]}/t #{prices[:nickel][:trend]} from #{mon_old[:day]} morning #{mon_old[:num_month]}"


		#Energy Commodities
		coal = "COAL Richards Bay Thermal Coal #{fri_new[:full]} close: $#{PricesModule::check_rounding(prices[:coal][:new].to_f.round(1))}/t #{prices[:coal][:trend]} from #{fri_old[:full]} close"
		oil = "OIL Today’s afternoon price in Asia: $#{PricesModule::check_rounding(prices[:oil][:new].to_f.round(1))}/b #{prices[:oil][:trend]} from #{mon_old[:day]} morning #{mon_old[:num_month]}"
		gas = "GAS Henry Hub #{fri_new[:full]} close: $#{PricesModule::check_rounding(prices[:gas][:new].to_f.round(2))}/mBtu #{prices[:gas][:trend]} from #{fri_old[:full]} close"
		uranium = "URANIUM U3O8 #{fri_new[:full]} close: $#{PricesModule::check_rounding(prices[:uranium][:new].to_f.round(1))}/lb #{prices[:uranium][:trend]} from #{fri_old[:full]} close"
		
		
		

		
		@price_points = {
	
			:baltic => baltic,
			:iron_ore => iron_ore,
			:manganese => manganese_ore,
			:chrome => chrome_ore,
			:gold => gold,
			:platinum => platinum,
			:palladium => palladium,
			:diamonds => diamonds,
			:copper => copper,
			:nickel => nickel,
			:aluminium => aluminium,
			:coal => coal,
			:oil => oil,
			:gas => gas,
			:uranium => uranium
		}
    
	end
	
	
	
end
