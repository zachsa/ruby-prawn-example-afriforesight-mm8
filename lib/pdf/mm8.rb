require 'prawn'
require 'sanitize'





def draw_price_point(col, pdf, prices, comm)
    
	left_margin = 298.5
	
	if col == 2 
		x = left_margin
	else
		x = 0
	end
	
	pdf.bounding_box([x-1, pdf.cursor], :width => 287, :height => 13) do
		pdf.stroke_color "6E2009"
		pdf.stroke do
			pdf.fill_color "6E2009"
			pdf.fill_and_stroke_rounded_rectangle [pdf.cursor - 12,pdf.cursor], 287, 13, 0
			pdf.fill_color 'FFFFFF'
		end

		pdf.move_down 3.3
		pdf.text(prices[comm], size: 6.9, :indent_paragraphs => 4, :inline_format => true, :style => :bold)
		pdf.fill_color '000000'
	end
end







def draw_stories(position, pdf, prices, after_price_break, section_break, stories_format, stories, comm)
	draw_price_point(position, pdf, prices, comm)
	pdf.move_down after_price_break
	stories.each do |s|
		pdf.text(s, stories_format)
	end
	pdf.move_down section_break
end







def heading(txt, pdf, main_content_heading, main_heading_break, format)
	pdf.fill_color "6E2009"
	pdf.font 'Arial Narrow', :style => :bold_italic
	pdf.text(txt, format)
	pdf.font 'Arial Narrow', :style => :normal
	main_heading_break	
end



def check_position(positions, pos, pdf)
  if pdf.cursor < 20
    pdf.move_down 20
    pdf.text(' ')
    positions[pos] = pdf.cursor
  else
    positions[pos] = pdf.cursor
  end
  positions
end



def draw_pdf(world_growth, commodity_news, prices, date_period, world_growth_font_size, general_stories_font_size, content_font_size)
	#Initialize variables
	general_stories = commodity_news[:general_stories]
	iron_ore_stories = commodity_news[:iron_ore]
	manganese_ore_stories = commodity_news[:manganese_ore]
	chrome_ore_stories = commodity_news[:chrome_ore]
	gold_stories = commodity_news[:gold]
	pgm_stories = commodity_news[:pgm]
	diamonds_stories = commodity_news[:diamonds]
	copper_stories = commodity_news[:copper]
	aluminium_stories = commodity_news[:aluminium]
	nickel_stories = commodity_news[:nickel]
	coal_stories = commodity_news[:coal]
	oil_gas_stories = commodity_news[:oil_gas]
	uranium_stories = commodity_news[:uranium]
	
  content = []
	commodity_news.each do |comm, arr|
		content.push arr
	end
	
	#general_stories_font_size = calculate_font_size("general", general_stories, 130)
	general_stories_format = {:size => general_stories_font_size, :align => :justify, :inline_format => true}
	
	world_overview_format = {:size => world_growth_font_size, :align => :justify}
	
	content_space = (620*2) - 270

	
	stories_font_size = content_font_size
	
	
	#Formats
	stories_format = {:size => stories_font_size, :align => :justify, :inline_format => true}
	main_content_heading = {:size => 9, :indent_paragraphs => 4}
	sub_content_heading = {:size => 8, :indent_paragraphs => 4}
	main_heading_break = 2
	section_break = 6
	after_price_break = 2
	
	
		
	pdf = Prawn::Document.generate("output/MM8.pdf", {:margin => [5,5], :page_size => 'A4'}) do |pdf|

		general_left = pdf.bounds.right/2 + 7
		general_right = pdf.bounds.right
	
		#Updates font registry to include custom fonts
		pdf.font_families.update("Arial Narrow" => {
			:normal => "#{BASEDIR}/lib/fonts/Arial Narrow.ttf",
			:bold => "#{BASEDIR}/lib/fonts/Arial Narrow Bold.ttf",
			:italic => "#{BASEDIR}/lib/fonts/Arial Narrow Italic.ttf",
			:bold_italic => "#{BASEDIR}/lib/fonts/Arial Narrow Bold Italic.ttf"
		})
		
		pdf.font_families.update("symbols" => {
			:normal => "#{BASEDIR}/lib/fonts/Typotheticals - Rhomus Omnilots.ttf",
			:bold => "#{BASEDIR}/lib/fonts/Typotheticals - Rhomus Omnilots.ttf",
			:italic => "#{BASEDIR}/lib/fonts/Typotheticals - Rhomus Omnilots.ttf",
			:bold_italic => "#{BASEDIR}/lib/fonts/Typotheticals - Rhomus Omnilots.ttf"

		})
		#Selects the custom font
		pdf.font('Arial Narrow')
		

	
	
		########## Header ##########
		
		
	
		pdf.draw_text("MONDAY MORNING MINING @ 8", :at => [0, 819], :size => 13, :style => :bold)
		pdf.draw_text('This page updates you quickly on key developments relating to mining and extraction over the last week and this Monday afternoon in Asia', :at => [0, 809], size: 8)
		pdf.draw_text(date_period, :at => [172, 819], :size => 8, :style => :bold)
		
		
		pdf.fill_color '6E2009'
		pdf.draw_text('GLOBAL ECONOMIC DEVELOPMENT', :at => [0, 793], :size => 10)
		pdf.draw_text('GENERAL MINING STORIES', :at => [general_left, 793], :size => 10)
		pdf.image "#{BASEDIR}/lib/images/logo.png", :at => [510, 832], :width => 70
	
		pdf.stroke do
			pdf.horizontal_line 0, (pdf.bounds.right/2 - 3), :at => 790
			pdf.horizontal_line general_left, general_right, :at => 790
			pdf.line_width = 0.05
		end






		########## GLOBAL SECTION ##########
	
		#World Overview
		pdf.bounding_box([0, 785], :width => (pdf.bounds.right/2 - 3), :height => 130) do
			pdf.text(world_growth, world_overview_format)
			pdf.move_down 2
			pdf.text(prices[:baltic], size: 6.9, :inline_format => true, :style => :bold)
		end
	
		#General Stories
		pdf.bounding_box([general_left, 785], :width => (pdf.bounds.right/2 - 9), :height => 130) do
			general_stories.each do |s|
				pdf.text(s, general_stories_format)
			end
		end
	
		pdf.stroke do
			pdf.horizontal_line 0, pdf.bounds.right, :at => 660
			pdf.line_width = 0.05
		end
		
		
		pdf.fill_color '000000'
		
		########## MAIN CONTENT ##########
		
		#Add Column format
		pdf.column_box([0, 650], :columns => 2, :width => pdf.bounds.width, :height => 630, :overflow => :truncate) do
			position = {'0' => pdf.cursor}
			col = 1
			
			current = pdf.cursor
						
			#METAL ORES HEADING 
			heading("METAL ORES", pdf, main_content_heading, main_heading_break, main_content_heading)			
			
			
			#Iron ore
			draw_stories(col, pdf, prices, after_price_break, section_break, stories_format, iron_ore_stories, :iron_ore)
			
      
      

      
      
      
      #Manganese ore
      position = check_position(position, '1', pdf)
			col = 2 if position['1'] - position['0'] > 0
			
			draw_stories(col, pdf, prices, after_price_break, section_break, stories_format, manganese_ore_stories, :manganese)




			#Chrome ore
      position = check_position(position, '2', pdf)
			col = 2 if position['2'] - position['1'] > 0
      
			draw_stories(col, pdf, prices, after_price_break, section_break, stories_format, chrome_ore_stories, :chrome)
			
			
      
      #PRECIOUS METALS HEADING
      position = check_position(position, '3', pdf)
			col = 2 if position['3'] - position['2'] > 0

			heading("PRECIOUS METALS", pdf, main_content_heading, main_heading_break, main_content_heading)
			
      
      #Gold	
			draw_stories(col, pdf, prices, after_price_break, section_break, stories_format, gold_stories, :gold)



			#Platinum & Palladium Heading
      position = check_position(position, '4', pdf)
			col = 2 if position['4'] - position['3'] > 0

			heading("Platinum & Palladium", pdf, main_content_heading, main_heading_break, sub_content_heading)	

				
			
			#PGM
			draw_price_point(col, pdf, prices, :platinum)
			
      position = check_position(position, '5', pdf)
			col = 2 if position['5'] - position['4'] > 0
						
			draw_price_point(col, pdf, prices, :palladium)
			
			
			pdf.move_down after_price_break
			pgm_stories.each do |s|
				pdf.text(s, stories_format)
			end
			pdf.move_down section_break
			
			
      
			#Diamonds	
			position = check_position(position, '6', pdf)
			col = 2 if position['6'] - position['5'] > 0
      		
			draw_stories(col, pdf, prices, after_price_break, section_break, stories_format, diamonds_stories, :diamonds)
			
      
      
			#BASE METALS HEADING
			position = check_position(position, '7', pdf)
			col = 2 if position['7'] - position['6'] > 0
			
			heading("BASE METALS", pdf, main_content_heading, main_heading_break, main_content_heading)		
			


			#Copper		
			draw_stories(col, pdf, prices, after_price_break, section_break, stories_format, copper_stories, :copper)			
			
      
      
      #Aluminium	
			position = check_position(position, '8', pdf)
			col = 2 if position['8'] - position['7'] > 0
		
			draw_stories(col, pdf, prices, after_price_break, section_break, stories_format, aluminium_stories, :aluminium)
			
      
      
      
      #Nickel	
			position = check_position(position, '9', pdf)
			col = 2 if position['9'] - position['8'] > 0
					
			draw_stories(col, pdf, prices, after_price_break, section_break, stories_format, nickel_stories, :nickel)
			
      
      
      #ENERGY COMMODITIES HEADING
			position = check_position(position, '10', pdf)
			col = 2 if position['10'] - position['9'] > 0		
			
			heading("ENERGY COMMODITIES", pdf, main_content_heading, main_heading_break, main_content_heading)		
      
      	
			
      
			#Coal			
			draw_stories(col, pdf, prices, after_price_break, section_break, stories_format, coal_stories, :coal)
      
      
      
      
      
      #Oil & Gas Heading
			position['11'] = pdf.cursor
			col = 2 if position['11'] - position['10'] > 0
			
			position = check_position(position, '11', pdf)
			col = 2 if position['11'] - position['10'] > 0

			heading("Oil & Gas", pdf, main_content_heading, main_heading_break, sub_content_heading)		
			
		
			#Oil & Gas		
			draw_price_point(col, pdf, prices, :oil)	

		
			position = check_position(position, '12', pdf)
			col = 2 if position['12'] - position['11'] > 0

			draw_price_point(col, pdf, prices, :gas)
			
			pdf.move_down after_price_break
			oil_gas_stories.each do |s|
				pdf.text(s, stories_format)
			end
			pdf.move_down section_break
			
			
      
      
      
      
      
      #Uranium	
			position = check_position(position, '13', pdf)
			col = 2 if position['13'] - position['12'] > 0
			
				
			draw_stories(col, pdf, prices, after_price_break, section_break, stories_format, uranium_stories, :uranium)
			position['14'] = pdf.cursor
			col = 2 if position['14'] - position['13'] > 0
			
			
		end
		
		
		
		
		########## Middle Line ##########
		pdf.stroke do
			pdf.vertical_line 25, 650, :at => 293
			pdf.line_width = 0.05
		end
	
	
	
	
	
		########## FOOTER ##########

		pdf.stroke do
			pdf.horizontal_line 0, pdf.bounds.right, :at => 20
			pdf.line_width = 0.05
		end


		pdf.move_down 5
		pdf.text('Disclaimer: The publication’s content is confidential and only for the use of the recipient and remains proprietary to Afriforesight . You may not copy or distribute this document without our written consent. The writers work fast to get the info to you asap and we can make no warranties in respect of accuracy. Any forecast made is just the writer’s best guess and we strongly advise you not to take any risky decisions on them.', :size => 6)

	end
end
	
