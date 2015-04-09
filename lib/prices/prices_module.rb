module PricesModule
	extend self
	
	def make_bold(prices)
		prices.clone.each do |comm, p|
			
			puts p
			#name = "<font size='8.5'>#{arr[0]}</font>"
			#prices[comm] = "<b>#{name} #{arr[1]}</b>"
		end
		
		prices
	end
	
	def convert_date(date)
		dates = {}
	
		new_date_s = change_date_format(date)
		dates[:day] = new_date_s[:day]
		dates[:num] = new_date_s[:num].sub(/^0/, "")  
		dates[:month] = new_date_s[:month]
		dates[:num_month] = "#{dates[:num]} #{dates[:month]}"
		dates[:full] = "#{dates[:day]} #{dates[:num]} #{dates[:month]}"
	
		dates
	end
	
	
	
	def change_date_format(d)
		require 'date'
		date_strings = {}
	
		date = d.strftime("%a %d %b")
		date = date.split(" ")
	
		date_strings[:day] = date[0]
		date_strings[:num] = date[1]
		date_strings[:month] = date[2]
	
		#Add %Y to the strftime argument to get the year as well
		#date_strings[:year] = date[3]
	
		#If I want the whole date (but for now I'm combining the split varaibles)
		#date_strings[:full] = "#{date_strings[:day]} #{date_strings[:num]} #{date_strings[:month]}"

		date_strings
	end
	
	
	
	
	
	#A thousands separator
	def separate(n,c=' ')
		if n > 1000
			n = n.round(0)
		end
	
		begin
			m = n
	  	  	str = ''
	  	  	loop do
	    		m,r = m.divmod(1000)
	    		return str.insert(0,"#{r}") if m.zero?
	    		str.insert(0,"#{c}#{"%03d" % r}")
	  	  	end
		rescue
			"- - -"
		end
	end
	
	
	
	
	def check_rounding(f)
		if f.round(2).to_s[/.$/] == "0"
			if f.round(1).to_s[/.$/] = "0"
				return f.round
			else
				return f.round(1)
			end
		else
			return f.round(2)
		end
	end
	
	
	

	def price_direction(c)	
		c = check_rounding(c.round(1))
		if c > 0.5
			return "UP #{c.abs}%"
		elsif c < -0.5
			return "DOWN #{c.abs}%"
		else
			return "SIDE"
		end
	end





	def latest_price_tonne(p)
		price = p.to_f*38*1.0
		price = price.round(1)
		check_rounding(price)
	end
	
	
	
	
	
	def get_prices(file)
		prices = {}
	
		baltic_dry = {}
		baltic_dry[:new] = file.cell('E', 4)
		baltic_dry[:old] = file.cell('C', 4)
		prices[:baltic_dry] = baltic_dry

		baltic_dry_cape = {}
		baltic_dry_cape[:new] = file.cell('E', 5)
		baltic_dry_cape[:old] = file.cell('C', 5)
		prices[:baltic_dry_cape] = baltic_dry_cape

		iron_ore = {}
		iron_ore[:new] = file.cell('E', 6)
		iron_ore[:old] = file.cell('C', 6)
		prices[:iron_ore] = iron_ore

		manganese = {}
		manganese[:new] = file.cell('E', 11)
		manganese[:old] = file.cell('C', 11)
		prices[:manganese] = manganese

		chrome = {}
		chrome[:new] = file.cell('E', 12)
		chrome[:old] = file.cell('C', 12)
		prices[:chrome] = chrome

		gold = {}
		gold[:new] = file.cell('G', 13)
		gold[:old] = file.cell('D', 13)
		prices[:gold] = gold

		platinum = {}
		platinum[:new] = file.cell('G', 14)
		platinum[:old] = file.cell('D', 14)
		prices[:platinum] = platinum

		palladium = {}
		palladium[:new] = file.cell('G', 15)
		palladium[:old] = file.cell('D', 15)
		prices[:palladium] = palladium

		diamonds = {}
		diamonds[:new] = file.cell('E', 16)
		diamonds[:old] = file.cell('C', 16)
		prices[:diamonds] = diamonds

		copper = {}
		copper[:new] = file.cell('G', 17)
		copper[:old] = file.cell('D', 17)
		prices[:copper] = copper

		aluminium = {}
		aluminium[:new] = file.cell('G', 18)
		aluminium[:old] = file.cell('D', 18)
		prices[:aluminium] = aluminium

		nickel = {}
		nickel[:new] = file.cell('G', 20)
		nickel[:old] = file.cell('D', 20)
		prices[:nickel] = nickel

		coal = {}
		coal[:new] = file.cell('E', 21)
		coal[:old] = file.cell('C', 21)
		prices[:coal] = coal

		oil = {}
		oil[:new] = file.cell('G', 22)
		oil[:old] = file.cell('D', 22)
		prices[:oil] = oil

		gas = {}
		gas[:new] = file.cell('E', 23)
		gas[:old] = file.cell('C', 23)
		prices[:gas] = gas

		uranium = {}
		uranium[:new] = file.cell('E', 25)
		uranium[:old] = file.cell('C', 25)
		prices[:uranium] = uranium

		prices			
	end
	
	
end