require 'prawn'
require 'sanitize'

def draw_energy_price_point(col, pdf, prices, comm)
  
  #Sanitize.fragment(prices[comm]).split(/(?=\p{Zs}(\p{Lu}\p{Ll}+.*))\p{Zs}/)
  
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
		
		#pdf.pad(4) do
		#	pdf.draw_text(prices[comm], :at => [4, pdf.cursor - 4], :size => 7, :inline_format => true, :style => :bold_italic)
		#end
		pdf.move_down 3.3
		pdf.text(prices[comm], size: 6.9, :indent_paragraphs => 4, :inline_format => true, :style => :bold)
		pdf.fill_color '000000'
		
		
		#if comm == :iron_ore
		#	pdf.fill_color '6E2009'
		#	pdf.fill_rectangle [146.5, 12], 8, 11 
		#	pdf.fill_color '000000'
		#	pdf.fill_polygon [147, 10], [152, 6], [157, 2]
		#	pdf.fill_color '000000'
		#end
		
	end
end





def draw_energy_stories(position, pdf, prices, after_price_break, section_break, stories_format, stories, comm)
	draw_energy_price_point(position, pdf, prices, comm)
	pdf.move_down after_price_break
	stories.each do |s|
		pdf.text(s, stories_format)
	end
	pdf.move_down section_break
end








def draw_energy_pdf(world_growth, commodity_news, prices, date_period, world_growth_font_size, general_stories_font_size, content_font_size)
	#Initialize variables
	general_stories = commodity_news[:general_stories]
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
	#Heading = 6 x 2pts
	#Price points = 10 x 12pts
	#after_price_break = 12 x 2pts
	#section_break = 11 x 6pts
	
	stories_font_size = content_font_size
	
	
	#Formats
	stories_format = {:size => stories_font_size, :align => :justify, :inline_format => true}
	main_content_heading = {:size => 9, :indent_paragraphs => 4}
	sub_content_heading = {:size => 8, :indent_paragraphs => 4}
	main_heading_break = 2
	section_break = 6
	after_price_break = 2
	
	
		
	pdf = Prawn::Document.generate("output/energy.pdf", {:margin => [5,5], :page_size => 'A4'}) do |pdf|

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
		pdf.bounding_box([0, 785], :width => (pdf.bounds.right/2 - 3), :height => 210) do
			pdf.text(world_growth, world_overview_format)
			pdf.move_down 2
			pdf.text(prices[:baltic], size: 6.9, :inline_format => true, :style => :bold)
		end
	
		#General Stories
		pdf.bounding_box([general_left, 785], :width => (pdf.bounds.right/2 - 9), :height => 210) do
			general_stories.each do |s|
				pdf.text(s, general_stories_format)
			end
		end
	
		pdf.stroke do
			pdf.horizontal_line 0, pdf.bounds.right, :at => 590
			pdf.line_width = 0.05
		end
		
		
		pdf.fill_color '000000'
		
		########## MAIN CONTENT ##########
		
		#Add Column format
		pdf.column_box([0, 580], :columns => 2, :width => pdf.bounds.width, :height => 560, :overflow => :truncate) do
			position = {'0' => pdf.cursor}
			col = 1
      
      
			
						


						
			#Oil & Gas		
			draw_price_point(col, pdf, prices, :oil)	
			if pdf.cursor < 20
				pdf.move_down 20
				pdf.text(" ")
				position['1'] = pdf.cursor
			else 
				position['1'] = pdf.cursor
			end
			col = 2 if position['1'] - position['0'] > 0

			draw_price_point(col, pdf, prices, :gas)
			pdf.move_down after_price_break
		
    
    	oil_gas_stories.each do |s|
				pdf.text(s, stories_format)
			end
			pdf.move_down section_break
			
			
			
      
      
    
			#Coal	  
      if pdf.cursor < 20
				pdf.move_down 20
				pdf.text(" ")
				position['2'] = pdf.cursor
			else 
				position['2'] = pdf.cursor
			end
			col = 2 if position['2'] - position['1'] > 0
		
			draw_energy_stories(col, pdf, prices, after_price_break, section_break, stories_format, coal_stories, :coal)

			
			
      
			#Uranium	      
      if pdf.cursor < 20
				pdf.move_down 20
				pdf.text(" ")
				position['3'] = pdf.cursor
			else 
				position['3'] = pdf.cursor
			end
			col = 2 if position['3'] - position['2'] > 0

			draw_energy_stories(col, pdf, prices, after_price_break, section_break, stories_format, uranium_stories, :uranium)

			
			
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
	
