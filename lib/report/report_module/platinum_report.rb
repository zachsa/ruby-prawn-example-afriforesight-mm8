require_relative 'base.rb'
  
class Report::PlatinumReport < Report::Base
  def initialize(world_growth, commodity_news, prices, date_period, world_growth_font_size, general_stories_font_size, content_font_size, default_prawn_options = {:margin => [5,5], :page_size => 'A4'})
    super(world_growth, commodity_news, prices, date_period, world_growth_font_size, general_stories_font_size, content_font_size, default_prawn_options)
    generate_report('Platinum Report')
  end
  
  
  def header
    #Set parameters for the heading
    title_options = {:at => [0, 819], :size => 14, :style => :bold}
    caption_options = {:at => [0, 807], size: 8}
    date_text_options = {:at => [182, 819], :size => 8, :style => :bold}
    
    global_section_heading_options = {:at => [0, 781], :size => 10, :style => :bold}
    general_section_heading_options = {:at => [@general_left, 781], :size => 10, :style => :bold}
    image_heading_options = {:at => [484, 832], :width => 100}
    header_line_y = 778
    
    header = self.extend(Report).header_template(title_options, caption_options, date_text_options, global_section_heading_options, general_section_heading_options, image_heading_options, header_line_y)
  end
  
  

  def global_section
    global_section_height = 266 #header_line_y - global_section_bottom_line
    global_section_bottom_line = 512
    content_y = 775
    
    global_section = self.extend(Report).global_section_template(global_section_height, global_section_bottom_line, content_y)
  end
  
  

  def main_content
		#Add Column format
		self.column_box([0, 502], :columns => 2, :width => self.bounds.width, :height => 482, :overflow => :truncate) do
			position = {'0' => self.cursor}
			col = 1
      
      #PGM
      position = check_position(position, '1', self)      
			col = 2 if position['1'] - position['0'] > 0
			draw_price_point(col, self, @prices, :platinum, 13)
      position = check_position(position, '2', self)
			col = 2 if position['2'] - position['1'] > 0
			draw_price_point(col, self, @prices, :palladium, 13)
			draw_stories(self, @after_price_break, @section_break, @stories_format, @pgm_stories)
      
      
			#Chrome ore
      position = check_position(position, '3', self)
			col = 2 if position['3'] - position['2'] > 0
      draw_price_point(col, self, @prices, :chrome, 13)
			draw_stories(self, @after_price_break, @section_break, @stories_format, @chrome_ore_stories)
      
			#Copper
			position = check_position(position, '4', self)
			col = 2 if position['4'] - position['3'] > 0		
      draw_price_point(col, self, @prices, :copper, 13)	
			draw_stories(self, @after_price_break, @section_break, @stories_format, @copper_stories)	
      
      #Gold	
      position = check_position(position, '5', self)
			col = 2 if position['5'] - position['4'] > 0
      draw_price_point(col, self, @prices, :gold, 13)
			draw_stories(self, @after_price_break, @section_break, @stories_format, @gold_stories)
      
      #Nickel	
			position = check_position(position, '6', self)
			col = 2 if position['6'] - position['5'] > 0
			draw_price_point(col, self, @prices, :nickel, 13)	
			draw_stories(self, @after_price_break, @section_break, @stories_format, @nickel_stories)
		end
		
		########## Middle Line ##########
		self.stroke do
			self.vertical_line 25, 502, :at => 293
			self.line_width = 0.05
		end
  end
  
  def footer
    footer = self.extend(Report).footer_template
  end  

end
  
