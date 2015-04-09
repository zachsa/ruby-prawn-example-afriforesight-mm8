require 'prawn'


def draw_price_point(col, pdf, prices, comm)
	left_margin = 298.5
	
	if col == 2
		x = left_margin
	else
		x = 0
	end
	
			
	pdf.bounding_box([x, pdf.cursor], :width => 250, :height => 12) do
		pdf.stroke_color "894131"
		pdf.stroke do
			pdf.fill_color "894131"
			pdf.fill_and_stroke_rounded_rectangle [pdf.cursor - 12,pdf.cursor], 288, 12, 0
			pdf.fill_color 'FFFFFF'
		end
		
		pdf.pad(5) do
			pdf.draw_text(prices[comm], :at => [4, pdf.cursor - 4], :size => 7, :inline_format => true)
		end
		pdf.fill_color '000000'
	end
		
end










def calculate_font_size(commodity_news)
	fonts_table = {
		'3' => 217,
		'3.5' => 186,
		'4' => 163, 
		'4.5' => 145,
		'5' => 130,
		'5.5' => 180,
		'6' => 108,
		'6.5' => 100,
		'7' => 93,
		'7.5' => 86,
		'8' => 81,
		'8.5' => 76,
		'9' => 72,
		'10' => 65,
		'10.5' => 62,
		'11' => 59, 
		'11.5' => 56,
		'12' => 54,
		'12.5' => 52,
		'13' => 50
	}
	
	general_stories = commodity_news[:general_stories]
	general_stories_count = {}
	for i in 0...general_stories.length do
		general_stories_count["story#{i}".to_sym] = general_stories[i].length
	end
	sum = 0
	general_stories_count.each do |story, count|
		sum += count
	end
	general_stories_percent = {}
	general_stories_count.each do |story, count|
		general_stories_percent[story] = count.to_f/sum*100
	end
	#Keeps track of the closes font size
	closest_size = 0
	max_lines = 130
	
	closest_size = 0
	max_line_height = 0
	
	#Cycle thorugh each font table to test each size
	fonts_table.each do |size, chars|			
		#Count lines
		total_lines = 0
		general_stories_count.each do |story, count|			
			lines = count/(fonts_table[size].to_f)
			total_lines += lines
		end
		height = (total_lines * 1.069 * size.to_f).floor + 20
		
		
		
		if height > max_line_height && height < 130
			max_line_height = height
			closest_size = size.to_f
		end
	end
	closest_size
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
	pdf.fill_color "894131"
	pdf.font 'Arial Narrow', :style => :bold_italic
	pdf.text(txt, format)
	pdf.font 'Arial Narrow', :style => :normal
	main_heading_break	
end


def check_col(col, pdf)
	if pdf.cursor < 13
		pdf.move_down 20
		pdf.text(" ")
		col = 2
	end
	
	if pdf.cursor > 611
		col = 2
	end
	col
end



def draw_pdf(commodity_news, prices)
	general_stories_font_size = calculate_font_size(commodity_news)
	general_stories_format = {:size => general_stories_font_size, :align => :justify, :inline_format => true}
	
	
	

	#Initialize variables
	general_stories = commodity_news[:general_stories]
	iron_ore_stories = commodity_news[:iron_ore]
	manganese_ore_stories = commodity_news[:manganese_ore]
	chrome_ore_stories = commodity_news[:chrome_ore]
	gold_stories = commodity_news[:gold]
	pgm_stories = commodity_news[:pgm]
	diamonds_stories = commodity_news[:pgm]
	copper_stories = commodity_news[:copper]
	aluminium_stories = commodity_news[:aluminium]
	nickel_stories = commodity_news[:nickel]
	coal_stories = commodity_news[:coal]
	oil_gas_stories = commodity_news[:oil_gas]
	uranium_stories = commodity_news[:uranium]
	
	
	#Formats
	stories_format = {:size => 6, :align => :justify, :inline_format => true}
	main_content_heading = {:size => 9}
	sub_content_heading = {:size => 8}
	main_heading_break = 2
	section_break = 6
	after_price_break = 2
	
	
		
	pdf = Prawn::Document.generate("output.pdf", {:margin => [5,5], :page_size => 'A4'}) do |pdf|

		general_left = pdf.bounds.right/2 + 7
		general_right = pdf.bounds.right
	
		#Updates font registry to include custom fonts
		pdf.font_families.update("Arial Narrow" => {
			:normal => "#{BASEDIR}/lib/fonts/Arial Narrow.ttf",
			:bold => "#{BASEDIR}/lib/fonts/Arial Narrow Bold.ttf",
			:italic => "#{BASEDIR}/lib/fonts/Arial Narrow Italic.ttf",
			:bold_italic => "#{BASEDIR}/lib/fonts/Arial Narrow Bold Italic.ttf"
		})
		#Selects the custom font
		pdf.font('Arial Narrow')
	
	
		########## Header ##########
	
		pdf.draw_text("MONDAY MORNING MINING @ 8", :at => [0, 822], :size => 12)
		pdf.draw_text('This page updates you quickly on key developments relating to mining and extraction over the last week and this Monday afternoon in Asia', :at => [0, 812], size: 8)
		pdf.draw_text('7 DAY PERIOD OF 02 - 09 FEBRUARY 2015', :at => [200, 822], :size => 8)
		pdf.draw_text('GLOBAL ECONOMIC DEVELOPMENT', :at => [0, 793], :size => 9)
		pdf.draw_text('GENERAL MINING STORIES', :at => [general_left, 793], :size => 9)
		pdf.image "#{BASEDIR}/lib/images/logo.png", :at => [510, 832], :width => 70
	
		pdf.stroke do
			pdf.horizontal_line 0, (pdf.bounds.right/2 - 20), :at => 790
			pdf.horizontal_line general_left, general_right, :at => 790
			pdf.line_width = 0.05
		end






		########## GLOBAL SECTION ##########
	
		#World Overview
		pdf.bounding_box([0, 785], :width => (pdf.bounds.right/2 - 20), :height => 130) do
			pdf.text('s'*50)
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
		
		
		
		
		########## MAIN CONTENT ##########
		
		#Add Column format
		pdf.column_box([0, 640], :columns => 2, :width => pdf.bounds.width, :height => 620, :overflow => :truncate) do
			
			col = 1
						
			#METAL ORES HEADING 
			heading("METAL ORES", pdf, main_content_heading, main_heading_break, main_content_heading)			
			
			check_col(col, pdf)
			
			#Iron ore
			draw_stories(col, pdf, prices, after_price_break, section_break, stories_format, iron_ore_stories, :iron_ore)
			
			
			col = check_col(col, pdf)


			#Manganese ore
			draw_stories(col, pdf, prices, after_price_break, section_break, stories_format, manganese_ore_stories, :manganese)
			
			
			col = check_col(col, pdf)

			
			#Chrome ore
			draw_stories(col, pdf, prices, after_price_break, section_break, stories_format, chrome_ore_stories, :chrome)
			
			
			col =  check_col(col, pdf)
			
			
			#PRECIOUS METALS HEADING
			heading("PRECIOUS METALS", pdf, main_content_heading, main_heading_break, main_content_heading)
			
			
			col = check_col(col, pdf)
			
			
			#Gold			
			draw_stories(col, pdf, prices, after_price_break, section_break, stories_format, gold_stories, :gold)
			
			
			col = check_col(col, pdf)
			
			
			#Platinum & Palladium Heading
			heading("Platinum & Palladium", pdf, main_content_heading, main_heading_break, sub_content_heading)	
			
			
			col = check_col(col, pdf)
				
			
			#PGM
			draw_price_point(col, pdf, prices, :platinum)
			col = check_col(col, pdf)
			draw_price_point(col, pdf, prices, :palladium)
			col = check_col(col, pdf)
			pdf.move_down after_price_break
			pgm_stories.each do |s|
				pdf.text(s, stories_format)
			end
			pdf.move_down section_break
			
			col = check_col(col, pdf)
			
			
			#Diamonds			
			draw_stories(col, pdf, prices, after_price_break, section_break, stories_format, diamonds_stories, :diamonds)
			
			col = check_col(col, pdf)
			
			
			
			#BASE METALS HEADING
			heading("BASE METALS", pdf, main_content_heading, main_heading_break, main_content_heading)		
			
			col = check_col(col, pdf)

			
			#Copper		
			draw_stories(col, pdf, prices, after_price_break, section_break, stories_format, copper_stories, :copper)
			
			col = check_col(col, pdf)

			
			#Aluminium			
			draw_stories(col, pdf, prices, after_price_break, section_break, stories_format, aluminium_stories, :aluminium)
			
			col = check_col(col, pdf)
			

			
			#Nickel			
			draw_stories(col, pdf, prices, after_price_break, section_break, stories_format, diamonds_stories, :nickel)
			
			col = check_col(col, pdf)
			

			
			
			
			#ENERGY COMMODITIES HEADING
			heading("ENERGY COMMODITIES", pdf, main_content_heading, main_heading_break, main_content_heading)		
			
			
			col = check_col(col, pdf)			
			
			
			#Coal			
			draw_stories(col, pdf, prices, after_price_break, section_break, stories_format, diamonds_stories, :coal)
			
			
			col = check_col(col, pdf)

			
			#Oil & Gas Heading
			heading("Oil & Gas", pdf, main_content_heading, main_heading_break, sub_content_heading)		
			
			
			col = check_col(col, pdf)			

						
			#Oil & Gas		
			draw_price_point(col, pdf, prices, :oil)	
			col = check_col(col, pdf)
			draw_price_point(col, pdf, prices, :gas)
			col = check_col(col, pdf)
			pdf.move_down after_price_break
			oil_gas_stories.each do |s|
				pdf.text(s, stories_format)
			end
			pdf.move_down section_break
			
			
			#Uranium		
			draw_stories(col, pdf, prices, after_price_break, section_break, stories_format, uranium_stories, :uranium)
			
			
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
	
