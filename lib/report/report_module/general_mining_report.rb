require_relative 'base.rb'

class Report::GeneralReport < Report::Base
  def initialize(world_growth, commodity_news, prices, date_period, world_growth_font_size, general_stories_font_size, content_font_size, default_prawn_options = {:margin => [5,5], :page_size => 'A4'})
    super(world_growth, commodity_news, prices, date_period, world_growth_font_size, general_stories_font_size, content_font_size, default_prawn_options)
    
    #Reassigns breaks
  	@after_price_break = 2
    
    
    format_prices
    puts "..Prices loaded successfully"
    generate_report('General Report')
    

  end
  
  def header
    #Set parameters for the heading
    title_options = {:at => [0, 819], :size => 13, :style => :bold}
    caption_options = {:at => [0, 809], size: 8}
    date_text_options = {:at => [172, 819], :size => 8, :style => :bold}
    
    global_section_heading_options = {:at => [0, 793], :size => 10, :style => :bold}
    general_section_heading_options = {:at => [@general_left, 793], :size => 10, :style => :bold}
    image_heading_options = {:at => [510, 832], :width => 70}
    header_line_y = 790
    
    header_template(title_options, caption_options, date_text_options, global_section_heading_options, general_section_heading_options, image_heading_options, header_line_y)
  end
  
  
  def global_section
    global_section_height = 130
    global_section_bottom_line = 660
    content_y = 785
    
    global_section_template(global_section_height, global_section_bottom_line, content_y)
  end
  
  
  def main_content
    price_point_size = 13
    vertical_padding = 0
        
		#Add Column format
		self.column_box([0, 650], :columns => 2, :width => self.bounds.width, :height => 630, :overflow => :truncate) do
			position = {'0' => self.cursor}
			col = 1
      									
			#METAL ORES HEADING 
			heading("METAL ORES", self, @main_heading_break, @main_content_heading_format)			
					
			#Iron ore
      draw_price_point(col, @prices, :iron_ore, price_point_size, vertical_padding)
      move_down @after_price_break
			draw_stories(self, @section_break, @stories_format, @iron_ore_stories)   
			

      #Manganese ore
      position = check_position(position, '1')
			col = 2 if position['1'] - position['0'] > 0
			draw_price_point(col, @prices, :manganese, price_point_size, vertical_padding)
      move_down @after_price_break
			draw_stories(self, @section_break, @stories_format, @manganese_ore_stories)

			#Chrome ore
      position = check_position(position, '2')
			col = 2 if position['2'] - position['1'] > 0
      draw_price_point(col, @prices, :chrome, price_point_size, vertical_padding)
      move_down @after_price_break
			draw_stories(self, @section_break, @stories_format, @chrome_ore_stories)
      
      #PRECIOUS METALS HEADING
      position = check_position(position, '3')
			col = 2 if position['3'] - position['2'] > 0
			heading("PRECIOUS METALS", self, @main_heading_break, @main_content_heading_format)
			

      #Gold	
      draw_price_point(col, @prices, :gold, price_point_size,vertical_padding)
      move_down @after_price_break
			draw_stories(self, @section_break, @stories_format, @gold_stories)
      
      
      
			#Platinum & Palladium Heading
      position = check_position(position, '4')
			col = 2 if position['4'] - position['3'] > 0
			heading("Platinum & Palladium", self, @main_heading_break, @sub_content_heading_format)	


			#PGM
			draw_price_point(col, @prices, :platinum, price_point_size, vertical_padding)
      position = check_position(position, '5')
			col = 2 if position['5'] - position['4'] > 0
			draw_price_point(col, @prices, :palladium, price_point_size, vertical_padding)
      move_down @after_price_break
			draw_stories(self, @section_break, @stories_format, @pgm_stories)

			#Diamonds	
			position = check_position(position, '6')
			col = 2 if position['6'] - position['5'] > 0
      draw_price_point(col, @prices, :diamonds, price_point_size, vertical_padding)
      move_down @after_price_break	
			draw_stories(self, @section_break, @stories_format, @diamonds_stories)
			
			#BASE METALS HEADING
			position = check_position(position, '7')
			col = 2 if position['7'] - position['6'] > 0
			heading("BASE METALS", self, @main_heading_break, @main_content_heading_format)		
			

			#Copper
      draw_price_point(col, @prices, :copper, price_point_size, vertical_padding)
      move_down @after_price_break	
			draw_stories(self, @section_break, @stories_format, @copper_stories)			
      
      #Aluminium	
			position = check_position(position, '8')
			col = 2 if position['8'] - position['7'] > 0
      draw_price_point(col, @prices, :aluminium, price_point_size, vertical_padding)
      move_down @after_price_break
			draw_stories(self, @section_break, @stories_format, @aluminium_stories)
      
      
      #Nickel	
			position = check_position(position, '9')
			col = 2 if position['9'] - position['8'] > 0
			draw_price_point(col, @prices, :nickel, price_point_size, vertical_padding)
      move_down @after_price_break
			draw_stories(self, @section_break, @stories_format, @nickel_stories)
			
      
      #ENERGY COMMODITIES HEADING
			position = check_position(position, '10')
			col = 2 if position['10'] - position['9'] > 0		
			heading("ENERGY COMMODITIES", self, @main_heading_break, @main_content_heading_format)		
      
			#Coal	
      draw_price_point(col, @prices, :coal, price_point_size, vertical_padding)
      move_down @after_price_break		
			draw_stories(self, @section_break, @stories_format, @coal_stories)
      
      #Oil & Gas Heading
			position['11'] = self.cursor
			col = 2 if position['11'] - position['10'] > 0
			position = check_position(position, '11')
			col = 2 if position['11'] - position['10'] > 0
			heading("Oil & Gas", self, @main_heading_break, @sub_content_heading_format)		
			
			#Oil & Gas		
			draw_price_point(col, @prices, :oil, price_point_size, vertical_padding)	
			position = check_position(position, '12')
			col = 2 if position['12'] - position['11'] > 0
			draw_price_point(col, @prices, :gas, price_point_size, vertical_padding)
      move_down @after_price_break
      draw_stories(self, @section_break, @stories_format, @oil_gas_stories)
			
      #Uranium	
			position = check_position(position, '13')
			col = 2 if position['13'] - position['12'] > 0
			draw_price_point(col, @prices, :uranium, price_point_size, vertical_padding)
      move_down @after_price_break
			draw_stories(self, @section_break, @stories_format, @uranium_stories)
		end
		
		########## Middle Line ##########
    
    stroke_color @brown
    
		stroke do
			vertical_line 25, 650, :at => 293
			line_width = 0.05
		end
  end
  
   
  def footer
    footer_template
  end
  
  
	def format_prices
		@prices.clone.each do |comm, p|
			arr = p.split " "
			
			for i in 0...arr.length do
				wrd = arr[i]
				if wrd.upcase == "SIDE" || wrd.upcase == "FLAT"
					arr[i] = "<font name='symbols' size='7.5'><color rgb='000000'> : </color></font>"
				elsif wrd.upcase == "DOWN"
					arr[i] = "<font name='symbols' size='7.5'><color rgb='D45A2A'> = </color></font>"
				elsif wrd.upcase == "UP"
					arr[i] = "<font name='symbols' size='7.5'><color rgb='74B743'> &lt; </color></font>"
				end
			end
			p = arr.join " "
			
			arr = p.split(/(?=\p{Zs}(\p{Lu}\p{Ll}+.*))\p{Zs}/)
			name = "<font size='8'><b><i>#{arr[0]}</i></b></font>"
      price = "<font size='6.9'><b>#{arr[1]}</b></font>"
      
			@prices[comm] = "#{name} #{price}"
		end
	end
  
end
