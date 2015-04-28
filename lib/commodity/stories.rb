require 'docx'
require 'sanitize'
require 'ap'

class StoriesJSON
	attr_accessor :content, :content_for_db


	def initialize(file)
		
		begin
			content = Docx::Document.open(file)
			content = content.to_html			
			content = content.gsub("–", "-")			
		rescue
			puts "Problem reading the docx file: Class StoriesJSON, initialize"
			exit
		end
		
		
		begin
			content = Sanitize.fragment(content)
		rescue
			puts "Problem with Sanitize gem"
			exit
		end
		
		
		begin
			content = split_content(content)
		rescue
			puts "Problem splicing stories with Regex"
			exit
		end
		


		content = split_stories_by_country(content)
		@content_for_db = Marshal.load(Marshal.dump(content))

		content = make_country_bold(content)		
		@content = join_formatted_data(content)
		
		
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
		#content needs to be clean data at this point
		
		#Function splits between country and story to allow for further formatting
		#Function breaks without a country entry
		
		#Clones the argument hash for easier debugging
		content_copy = Marshal.load(Marshal.dump(content))

		content.clone.each do |comm, stories|
			for i in 0...stories.count do
				
				begin
					content[comm][i]
					content[comm][i] = content[comm][i].sub("-", "<SPLIT HERE>").split("<SPLIT HERE>")
					content[comm][i][0].rstrip!
					content[comm][i][0].lstrip!
					content[comm][i][1].rstrip!
					content[comm][i][1].lstrip!
				rescue
					puts
					ap content_copy
					puts
					puts 'ERROR:'
					puts "Trying to split #{comm} at story No. #{i} - preceded by the story: #{content[comm][i-1]}"
				end
		
				begin
					if content[comm][i].count != 2
						raise 
					end
				rescue Exception
					puts ('Formatting error: check source DocX file. Each story needs a country entry')
					puts 'Exiting....'
					exit
				end
			end
		end
		
		content
	end
	
	
	
	
	def split_content(content)
		mm8 = {}
	


		
		#General stories
		begin
			general_stories = content[/GENERAL_STORIES.*IRON_STORIES/].gsub('IRON_STORIES', '').gsub('GENERAL_STORIES', '')
			general_stories = general_stories.split('\n')
			mm8[:general_stories] = general_stories
		rescue
			puts 'Unable to splice general stories'
			exit
		end
		
		
		
		
		#Bulk Metals
		
		
		#Iron ore stories
		begin
			iron_ore = content[/IRON_STORIES.*MANGANESE_STORIES/].gsub('IRON_STORIES', '').gsub('MANGANESE_STORIES', '')
			iron_ore = iron_ore.split('\n')

			mm8[:iron_ore] = iron_ore
		rescue
			puts 'Unable to splice iron ore stories'
			exit
		end
		
		
		
		#Manganese ore stories
		begin
			manganese_ore = content[/MANGANESE_STORIES.*CHROME_STORIES/].gsub('MANGANESE_STORIES', '').gsub('CHROME_STORIES', '')
			manganese_ore = manganese_ore.split('\n')

			mm8[:manganese_ore] = manganese_ore
		rescue
			puts 'Unable to splice manganese stories'
			exit
		end



		#Chrome ore stories
		begin
			chrome_ore = content[/CHROME_STORIES.*GOLD_STORIES/].gsub('CHROME_STORIES', '').gsub('GOLD_STORIES', '')
			chrome_ore = chrome_ore.split('\n')

			mm8[:chrome_ore] = chrome_ore
		rescue
			puts 'Unable to splice chrome stories'
			exit
		end
		
		
		
		#Precious Metals



		#Gold stories
		begin
			gold = content[/GOLD_STORIES.*PGM_STORIES/].gsub('GOLD_STORIES', '').gsub('PGM_STORIES', '')
			gold = gold.split('\n')

			mm8[:gold] = gold
		rescue
			puts 'Unable to splice gold stories'
			exit
		end
		
		
		
		#PGM stories
		begin
			pgm = content[/PGM_STORIES.*DIAMONDS_STORIES/].gsub('PGM_STORIES', '').gsub('DIAMONDS_STORIES', '')
			pgm = pgm.split('\n')

			mm8[:pgm] = pgm
		rescue
			puts "Unable to splice PGM stories"
			exit
		end


		#Diamond stories
		begin
			diamonds = content[/DIAMONDS_STORIES.*COPPER_STORIES/].gsub('DIAMONDS_STORIES', '').gsub('COPPER_STORIES', '')
			diamonds = diamonds.split('\n')

			mm8[:diamonds] = diamonds
		rescue
			puts 'Unable to splice diamond stories'
			exit
		end
		
		
		
		#Base Metals
		
		
		
		#Copper stories	
		begin
			copper = content[/COPPER_STORIES.*ALUMINIUM_STORIES/].gsub('COPPER_STORIES', '').gsub('ALUMINIUM_STORIES', '')
			copper = copper.split('\n')

			mm8[:copper] = copper
		rescue
			puts "Unable to splice copper stories"
			exit
		end


		#Aluminium stories
		begin
			aluminium = content[/ALUMINIUM_STORIES.*NICKEL_STORIES/].gsub('ALUMINIUM_STORIES', '').gsub('NICKEL_STORIES', '')
			aluminium = aluminium.split('\n')

			mm8[:aluminium] = aluminium
		rescue
			puts "Unable to splice aluminium stories"
			exit
		end


		#Nickel stories
		begin
			nickel = content[/NICKEL_STORIES.*COAL_STORIES/].gsub('NICKEL_STORIES', '').gsub('COAL_STORIES', '')
			nickel = nickel.split('\n')

			mm8[:nickel] = nickel
		rescue
			puts "Unable to splice nickel stories"
			exit
		end
		
		
		
		#Energy Commodities
		
		
		
		#Coal stories
		begin
			coal = content[/COAL_STORIES.*OIL_GAS_STORIES/].gsub('COAL_STORIES', '').gsub('OIL_GAS_STORIES', '')
			coal = coal.split('\n')

			mm8[:coal] = coal		
		rescue
			puts "Unable to splice coal stories"
			exit
		end
		
		
		#Oil & Gas
		begin
			oil_gas = content[/OIL_GAS_STORIES.*URANIUM_STORIES/].gsub('OIL_GAS_STORIES', '').gsub('URANIUM_STORIES', '')
			oil_gas = oil_gas.split('\n')

			mm8[:oil_gas] = oil_gas
		rescue
			puts "Unable to splice oil & gas stories"
			exit
		end
		
		
		#Uranium
		begin
			uranium = content[/URANIUM_STORIES.*/].gsub('URANIUM_STORIES', '')
			uranium = uranium.split('\n')

			mm8[:uranium] = uranium
		rescue
			puts "Unable to splice uranium stories"
			exit
		end
		
		
		
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



