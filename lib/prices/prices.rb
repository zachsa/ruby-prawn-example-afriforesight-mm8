class Prices
	attr_accessor :mon_new, :price_points

	def initialize(input_method)
		if input_method == :auto
			auto_generate_price_points
		else
			manual_generate_price_points
		end
	end

	def price_points_manual
		@price_points = {

			:baltic => "",
			:iron_ore => "IRON ORE Fri 22 May Qingdao, China close: $60/t DOWN 2.2% from Fri 15 May close",
			:manganese => "MANGANESE 37% grade PE Fri 22 May close: $2.28/dmtu ($84.4/t) UP 1.3% from Fri 15 May close",
			:chrome => "CHROME ORE Fri 22 May South Africa close: $158/t SIDE from Fri 15 May close",
			:gold => "GOLD Today’s afternoon price in Asia: $1 204/oz UP 1.3% from Mon morning 18 May",
			:platinum => "PLATINUM Today’s afternoon price in Asia: $1 145/oz UP 0.5% from Mon morning 18 May",
			:palladium => "PALLADIUM Today’s afternoon price in Asia: $790/oz DOWN 1.1% from Mon morning 18 May",
			:diamonds => "DIAMONDS overall polished price index Fri 22 May close: 131.1 DOWN 1.1% from Fri 15 May close",
			:copper => "COPPER Today’s afternoon price in Asia: $6 241/t DOWN 2.8% from Mon morning 18 May",
			:nickel => "NICKEL Today’s afternoon price in Asia: $12 588/t DOWN 5.8% from Mon morning 18 May",
			:aluminium => "ALUMINIUM Today’s afternoon price in Asia: $1 717/t DOWN 6.1% from Mon morning 18 May",
			:coal => "COAL Richards Bay Thermal Coal Fri 22 May close: $62.9/t DOWN 0.9% from Fri 15 May close",
			:oil => "OIL Today’s afternoon price in Asia: $65.3/b DOWN 2.4% from Mon morning 18 May",
			:gas => "GAS Henry Hub Fri 22 May close: $2.88/mBtu DOWN 2.6% from Fri 15 May close",
			:uranium => "URANIUM U3O8 Fri 22 May close: $35.3/lb DOWN 2.1% from Fri 15 May close"
		}
	end
	
	def find_excel_file
		txt = ""
		Dir.entries(BASEDIR).each do |i|
			txt = i if i[/xlsx/]
		end
		txt
	end
	
	def manual_generate_price_points
		begin	
			prices = price_points_manual
		rescue
			puts "ERROR: Problem using manual price points, check syntax"
		end
	end

	def auto_generate_price_points
		begin
			prices_xlsx = find_excel_file
		rescue
			puts "ERROR: Cannot locate Excel file"
			exit
		end

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
