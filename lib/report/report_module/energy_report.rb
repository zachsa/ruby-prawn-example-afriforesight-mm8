require_relative 'base.rb'

class Report::EnergyReport < Report::Base
  def initialize(world_growth, commodity_news, prices, date_period, world_growth_font_size, general_stories_font_size, content_font_size, default_prawn_options = {:margin => [5,5], :page_size => 'A4'})
    super(world_growth, commodity_news, prices, date_period, world_growth_font_size, general_stories_font_size, content_font_size, default_prawn_options)
    format_prices
    puts "..Prices loaded successfully"
    generate_report('Energy Report')
  end
  
  def header
    #Set parameters for the heading
    title_options = {:at => [0, 819], :size => 13, :style => :bold}
    caption_options = {:at => [0, 809], size: 8}
    date_text_options = {:at => [172, 819], :size => 8, :style => :bold}
    
    global_section_heading_options = {:at => [0, 773], :size => 10, :style => :bold}
    general_section_heading_options = {:at => [@general_left, 773], :size => 10, :style => :bold}
    image_heading_options = {:at => [510, 832], :width => 80}
    header_line_y = 770
    
    header = self.extend(Report).header_template(title_options, caption_options, date_text_options, global_section_heading_options, general_section_heading_options, image_heading_options, header_line_y)
  end
  
  def global_section
    global_section_height = 290
    global_section_bottom_line = 480
    content_y = 767
    
    global_section = self.extend(Report).global_section_template(global_section_height, global_section_bottom_line, content_y)
  end
  
  def main_content
		#Add Column format
		self.column_box([0, 470], :columns => 2, :width => self.bounds.width, :height => 450, :overflow => :truncate) do
			position = {'0' => self.cursor}
			col = 1

      #Oil & Gas	
			position = check_position(position, '1', self)
			col = 2 if position['1'] - position['0'] > 0	
			draw_price_point(col, self, @prices, :oil, 13)	
			position = check_position(position, '2', self)
			col = 2 if position['2'] - position['1'] > 0
			draw_price_point(col, self, @prices, :gas, 13)
      draw_stories(self, @after_price_break, @section_break, @stories_format, @oil_gas_stories)
 
			
      #Coal	
			position = check_position(position, '3', self)
			col = 2 if position['3'] - position['2'] > 0		
      draw_price_point(col, self, @prices, :coal, 13)			
			draw_stories(self, @after_price_break, @section_break, @stories_format, @coal_stories)

			
      #Uranium	
			position = check_position(position, '4', self)
			col = 2 if position['4'] - position['3'] > 0
			draw_price_point(col, self, @prices, :uranium, 13)
			draw_stories(self, @after_price_break, @section_break, @stories_format, @uranium_stories)
		end
		
		########## Middle Line ##########
		self.stroke do
			self.vertical_line 25, 470, :at => 293
			self.line_width = 0.05
		end
  end
  
  def footer
    footer = self.extend(Report).footer_template
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
			name = "<font size='8'><i>#{arr[0]}</i></font>"
			@prices[comm] = "<b>#{name} #{arr[1]}</b>"
		end
	end
  
end