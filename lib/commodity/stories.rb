require 'docx'
require 'sanitize'

class StoriesJSON
	attr_accessor :content, :content_for_db





	def initialize(file)
		
		begin
			content = Docx::Document.open(file).to_html.gsub("–", "-")
		rescue
			puts "Problem reading the docx file: Class StoriesJSON, initialize"
			exit
		end
		
		
		begin
			content = Sanitize.fragment(content)
		rescue
			puts "Problem with sanitize gem"
			exit
		end
		
		
		begin
			content = split_content(content)
		rescue
			puts "Problem splicing stories with Regex"
		end
		
		
		content = split_stories_by_country(content)
		content = make_country_bold(content)
		
		@content = join_formatted_data(content)
		@content_for_db = content
		
	end
	
	
	
	
	
	
	def join_formatted_data(arr)
		arr.clone.each do |commodity, stories|
			for i in 0...stories.length do
				arr[commodity][i] = arr[commodity][i].join(" - ")
			end
		end
	end
	
	
	
	
	
	def make_country_bold(arr)
		arr.clone.each do |commodity, stories|
			for i in 0...stories.length do
				txt = "<b>#{arr[commodity][i][0]}</b>"
				arr[commodity][i][0] = txt
			end
		end
		arr
	end
	
	
	
	
	
	def split_stories_by_country(content)
		content.clone.each do |k, v|
			for i in 0...v.length do
				content[k][i] = content[k][i].sub("-", "<SPLIT HERE>").split("<SPLIT HERE>")
				content[k][i][0].rstrip!
				content[k][i][0].lstrip!
				content[k][i][1].rstrip!
				content[k][i][1].lstrip!
		
				begin
					if content[k][i].count != 2
						raise 
					end
				rescue Exception
					puts ('Formatting error: check source DocX file. Each story needs a country entry')
					puts "Exiting...."
					exit
				end
			end
		end
		
		content
	end
	
	
	
	
	def split_content(content)
		mm8 = {}
		
		general_stories = content[/GENERAL MINING STORIES.*METAL ORES/].gsub('METAL ORES', '')
		metal_ores = content[/METAL ORES.*PRECIOUS METALS/].gsub('METAL ORES', '').gsub('PRECIOUS METALS', '')
		precious_metals = content[/PRECIOUS METALS.*BASE METALS/].gsub('BASE METALS', '').gsub('PRECIOUS METALS', '')
		base_metals = content[/BASE METALS.*ENERGY COMMODITIES/].gsub('BASE METALS', '').gsub('ENERGY COMMODITIES', '')
		energy_commodities = content[/ENERGY COMMODITIES.*/].gsub('ENERGY COMMODITIES', '')
		

		
		
		#General stories
		general_stories = general_stories.split('\n')
		general_stories.delete_at(0)		
		general_stories.delete_at(0)
		mm8[:general_stories] = general_stories
		
		
		
		#Bulk Metals
		
		
		
		#Iron ore stories
		iron_ore = metal_ores[/IRON ORE Fri.*MANGANESE Fri/].split('\n')
		iron_ore.delete_at((iron_ore.length - 1))
		iron_ore.delete_at(0)
		mm8[:iron_ore] = iron_ore
		
		
		#Manganese ore stories
		manganese_ore = metal_ores[/MANGANESE Fri.*CHROME ORE Fri/].split('\n')
		manganese_ore.delete_at((manganese_ore.length - 1))
		manganese_ore.delete_at(0)
		mm8[:manganese_ore] = manganese_ore


		#Chrome ore stories
		chrome_ore = metal_ores[/CHROME ORE Fri.*/].split('\n')
		chrome_ore.delete_at(0)
		mm8[:chrome_ore] = chrome_ore
		
		
		
		#Precious Metals



		#Gold stories
		gold = precious_metals[/GOLD Today.*Platinum &/].split('\n')
		gold.delete_at(gold.length - 1)
		gold.delete_at(0)
		mm8[:gold] = gold
		
		
		#PGM stories
		pgm = precious_metals[/PLATINUM Today.*DIAMONDS/].split('\n')
		pgm.delete_at(pgm.length - 1)
		pgm.delete_at(pgm.length - 1)
		pgm.delete_at(0)
		pgm.delete_at(0)
		mm8[:pgm] = pgm


		#Diamond stories
		diamonds = precious_metals[/DIAMONDS overall.*/].split('\n')
		diamonds.delete_at(0)
		mm8[:diamonds] = diamonds
		
		
		
		#Base Metals
		
		
		
		#Copper stories		
		copper = base_metals[/COPPER Today.*ALUMINIUM Today/].split('\n')
		copper.delete_at(copper.length - 1)
		copper.delete_at(0)
		mm8[:copper] = copper


		#Aluminium stories
		aluminium = base_metals[/ALUMINIUM Today.*NICKEL Today/].split('\n')
		aluminium.delete_at(aluminium.length - 1)
		aluminium.delete_at(0)
		mm8[:aluminium] = aluminium


		#Nickel stories
		nickel = base_metals[/NICKEL Today.*/].split('\n')
		nickel.delete_at(0)
		mm8[:nickel] = nickel
		
		
		
		#Energy Commodities
		
		
		
		#Coal stories
		coal = energy_commodities[/COAL Richards Bay.*Oil &amp; Gas/].split('\n')
		coal.delete_at(coal.length - 1)
		coal.delete_at(0)
		mm8[:coal] = coal		
		
		
		#Oil & Gas
		oil_gas = energy_commodities[/OIL Today.*URANIUM/].split('\n')
		oil_gas.delete_at(oil_gas.length - 1)
		oil_gas.delete_at(0)
		oil_gas.delete_at(0)
		mm8[:oil_gas] = oil_gas
		
		
		#Uranium
		uranium = energy_commodities[/URANIUM.*/].split('\n')
		uranium.delete_at(0)
		mm8[:uranium] = uranium
		
		
		
		mm8.clone.each do |comm,arr|
			arr.each do |story|
				if story.length < 10
					mm8[comm].delete(story)
				end
			end
		end
		
		mm8
	end

end



