require_relative 'base.rb'
  
class Report::PlatinumReport < Report::Base
  def initialize(world_growth, commodity_news, prices, date_period, world_growth_font_size, general_stories_font_size, content_font_size, default_prawn_options = {:margin => [5,5], :page_size => 'A4'})
    puts '..Drawing Platinum Report'
    super(world_growth, commodity_news, prices, date_period, world_growth_font_size, general_stories_font_size, content_font_size, default_prawn_options)
    
    #Reassigns breaks
  	@after_price_break = 10
    
    format_prices
    puts "..Prices loaded successfully"
    generate_report('Platinum Report')
    
    puts '..Platinum Report done'
  end
  
  
  def header
    #Set parameters for the heading
    title_options = {:at => [0, 819], :size => 14, :style => :bold}
    caption_options = {:at => [0, 806], size: 8}
    date_text_options = {:at => [182, 819], :size => 8, :style => :bold}
    
    global_section_heading_options = {:at => [0, 781], :size => 13, :style => :bold}
    general_section_heading_options = {:at => [@general_left, 781], :size => 13, :style => :bold}
    image_heading_options = {:at => [484, 832], :width => 100}
    header_line_y = 778
    
    header = header_template(title_options, caption_options, date_text_options, global_section_heading_options, general_section_heading_options, image_heading_options, header_line_y)
  end
  
  

  def global_section
    global_section_height = 266 #header_line_y - global_section_bottom_line
    global_section_bottom_line = 512
    content_y = 775
    
    global_section = self.extend(Report).global_section_template(global_section_height, global_section_bottom_line, content_y, 3)
  end
  
  

  def main_content
    price_point_size = 31
    vertical_padding = 5
    
		#Add Column format
		self.column_box([0, 502], :columns => 2, :width => self.bounds.width, :height => 482, :overflow => :truncate) do
			position = {'0' => self.cursor}
			col = 1
      
      #PGM
      position = check_position(position, '1')      
			col = 2 if position['1'] - position['0'] > 0
			draw_price_point(col, @prices, :platinum, price_point_size, vertical_padding)
      position = check_position(position, '2')
			col = 2 if position['2'] - position['1'] > 0
			draw_price_point(col, @prices, :palladium, price_point_size, vertical_padding)
      move_down @after_price_break
			draw_stories(self, @section_break, @stories_format, @pgm_stories)
      
      
			#Chrome ore
      position = check_position(position, '3')
			col = 2 if position['3'] - position['2'] > 0 - price_point_size	
      draw_price_point(col, @prices, :chrome, price_point_size, vertical_padding)
      move_down @after_price_break
			draw_stories(self, @section_break, @stories_format, @chrome_ore_stories)
      
			#Copper
			position = check_position(position, '4')
			col = 2 if position['4'] - position['3'] > 0 - price_point_size			
      draw_price_point(col, @prices, :copper, price_point_size, vertical_padding)
      move_down @after_price_break
			draw_stories(self, @section_break, @stories_format, @copper_stories)	
      
      #Gold	
      position = check_position(position, '5')
			col = 2 if position['5'] - position['4'] > 0 - price_point_size	
      draw_price_point(col, @prices, :gold, price_point_size, vertical_padding)
      move_down @after_price_break
			draw_stories(self, @section_break, @stories_format, @gold_stories)
      
      #Nickel	
			position = check_position(position, '6')
			col = 2 if position['6'] - position['5'] > 0 - price_point_size	
			draw_price_point(col, @prices, :nickel, price_point_size, vertical_padding)
      move_down @after_price_break
			draw_stories(self, @section_break, @stories_format, @nickel_stories)
		end
		
		########## Middle Line ##########
    
    stroke_color @brown
		stroke do 
			vertical_line 25, 502, :at => 293
			line_width = 0.05
		end
  end
  
  def footer
    footer = footer_template
  end
  
	def format_prices
		@prices.clone.each do |comm, p|
			arr = p.split " "
			
			for i in 0...arr.length do
				wrd = arr[i]
				if wrd.upcase == "SIDE" || wrd.upcase == "FLAT"
					arr[i] = "<font name='symbols' size='10'><color rgb='000000'> : </color></font>"
				elsif wrd.upcase == "DOWN"
					arr[i] = "<font name='symbols' size='10'><color rgb='D45A2A'> = </color></font>"
				elsif wrd.upcase == "UP"
					arr[i] = "<font name='symbols' size='10'><color rgb='74B743'> &lt; </color></font>"
				end
			end
			p = arr.join " "
			
			arr = p.split(/(?=\p{Zs}(\p{Lu}\p{Ll}+.*))\p{Zs}/)
			name = "<font size='11'><b><i>#{arr[0]}</i></b></font>"
      price = "<font size='8'><b>#{arr[1]}</b></font>"
      
      if comm == :baltic
        @prices[comm] = "#{name} #{price}"
      else
        @prices[comm] = "#{name}
        #{price}"
      end
		end
	end 

end
  
