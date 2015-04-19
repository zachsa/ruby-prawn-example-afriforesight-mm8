require 'prawn'
require_relative 'helpers'

module Report
  def header_template(title_options, caption_options, date_text_options, global_section_heading_options, general_section_heading_options, image_heading_options, header_line_y)
		self.draw_text("MONDAY MORNING MINING @ 8", title_options)
		self.draw_text('This page updates you quickly on key developments relating to mining and extraction over the last week and this Monday afternoon in Asia', caption_options)
		self.draw_text(@date_period, date_text_options)
		
		self.fill_color '6E2009'
		self.draw_text('GLOBAL ECONOMIC DEVELOPMENT', global_section_heading_options)
		self.draw_text('GENERAL MINING STORIES', general_section_heading_options)
		self.image "#{BASEDIR}/lib/images/logo.png", image_heading_options
	
		self.stroke do
			self.horizontal_line 0, (self.bounds.right/2 - 3), :at => header_line_y
			self.horizontal_line @general_left, @general_right, :at => header_line_y
			self.line_width = 0.05
		end
  end
  
  
  def global_section_template(global_section_height, global_section_bottom_line)
		#World Overview
		self.bounding_box([0, 785], :width => (self.bounds.right/2 - 3), :height => global_section_height) do
			self.text(@world_growth, @world_overview_format)
			self.move_down 2
			self.text(@prices[:baltic], size: 6.9, :inline_format => true, :style => :bold)
		end
		#General Stories
		self.bounding_box([@general_left, 785], :width => (self.bounds.right/2 - 9), :height => global_section_height) do
			@general_stories.each do |s|
				self.text(s, @general_stories_format)
			end
		end
		self.stroke do
			self.horizontal_line 0, self.bounds.right, :at => global_section_bottom_line
			self.line_width = 0.05
		end
    self.fill_color '000000'
  end
  
  
  def footer_template
		self.stroke do
			self.horizontal_line 0, self.bounds.right, :at => 20
			self.line_width = 0.05
		end
		self.move_down 5
		self.text('Disclaimer: The publication’s content is confidential and only for the use of the recipient and remains proprietary to Afriforesight . You may not copy or distribute this document without our written consent. The writers work fast to get the info to you asap and we can make no warranties in respect of accuracy. Any forecast made is just the writer’s best guess and we strongly advise you not to take any risky decisions on them.', :size => 6)
  end
end


class Report::DefaultReport < Prawn::Document
  #Initializes the document parameters and content instances
  #Creates the Prawn document
  def initialize(world_growth, commodity_news, prices, date_period, world_growth_font_size, general_stories_font_size, content_font_size, default_prawn_options = {:margin => [5,5], :page_size => 'A4'})
  
    #General variables
    @date_period = date_period
    @world_growth = world_growth
    @prices = prices
  
  	#Selects relevant stories
    @general_stories = commodity_news[:general_stories]
  	@iron_ore_stories = commodity_news[:iron_ore]
  	@manganese_ore_stories = commodity_news[:manganese_ore]
  	@chrome_ore_stories = commodity_news[:chrome_ore]
  	@gold_stories = commodity_news[:gold]
  	@pgm_stories = commodity_news[:pgm]
  	@diamonds_stories = commodity_news[:diamonds]
  	@copper_stories = commodity_news[:copper]
  	@aluminium_stories = commodity_news[:aluminium]
  	@nickel_stories = commodity_news[:nickel]
  	@coal_stories = commodity_news[:coal]
  	@oil_gas_stories = commodity_news[:oil_gas]
  	@uranium_stories = commodity_news[:uranium]
    
    #Font sizes
    @world_growth_font_size = world_growth_font_size
    @general_stories_font_size = general_stories_font_size
    @content_font_size = content_font_size
    
    #Colours
    @black = '000000'
    @white = 'FFFFFF'
    @brown = '6E2009'
    @up_arrow_color = '74B743' #Used in prices module (just for reference)
    @down_arrow_color = 'D45A2A' #Used in prices module (just for reference)
    @side_arrow_color = '000000' #Used in prices module (just for reference)
    
    #General section formatting
  	@general_stories_format = {:size => @general_stories_font_size, :align => :justify, :inline_format => true}
  	@world_overview_format = {:size => @world_growth_font_size, :align => :justify}
    
    #Main content formatting
  	@stories_format = {:size => @content_font_size, :align => :justify, :inline_format => true}
    
    #Headings formats
  	@main_content_heading_format = {:size => 9, :indent_paragraphs => 4}
  	@sub_content_heading_format = {:size => 8, :indent_paragraphs => 4}
    
    #Breaks formats
  	@main_heading_break = 2
  	@section_break = 6
  	@after_price_break = 2
    
    #Create document as self
    super(default_prawn_options)
    set_up_general
    generate_reports
  end
  
  
  def set_up_general
		@general_left = bounds.right/2 + 7
		@general_right = bounds.right
    
		font_families.update("Arial Narrow" => {
			:normal => "#{BASEDIR}/lib/fonts/Arial Narrow.ttf",
			:bold => "#{BASEDIR}/lib/fonts/Arial Narrow Bold.ttf",
			:italic => "#{BASEDIR}/lib/fonts/Arial Narrow Italic.ttf",
			:bold_italic => "#{BASEDIR}/lib/fonts/Arial Narrow Bold Italic.ttf"
		})
		font_families.update("symbols" => {
			:normal => "#{BASEDIR}/lib/fonts/Typotheticals - Rhomus Omnilots.ttf",
			:bold => "#{BASEDIR}/lib/fonts/Typotheticals - Rhomus Omnilots.ttf",
			:italic => "#{BASEDIR}/lib/fonts/Typotheticals - Rhomus Omnilots.ttf",
			:bold_italic => "#{BASEDIR}/lib/fonts/Typotheticals - Rhomus Omnilots.ttf"
		})
    self.font('Arial Narrow')
  end
  
  def generate_reports
    #General report
    begin
      general_report = self
      general_report.extend(Report::GeneralMiningReport)
      general_report.header
      general_report.global_section
      general_report.main_content
      general_report.footer
      general_report.render_file "#{BASEDIR}/output/Monday Morning Mining.pdf"
    rescue
      puts "Unable to generate General Report"
      exit
    end
    
    #Energy report
    #begin
      energy_report = self
      energy_report.extend(Report::EnergyReport)
      energy_report.header
      energy_report.global_section
      energy_report.main_content
      energy_report.footer
      energy_report.render_file "#{BASEDIR}/output/Energy Report.pdf"
      #rescue
      #puts "Unable to generate Energy Report"
      #exit
      #end
    
    #Platinum report
    begin
      platinum_report = self
      platinum_report.extend(Report::PlatinumReport)
      platinum_report.header
      platinum_report.global_section
      platinum_report.main_content
      platinum_report.footer
      platinum_report.render_file "#{BASEDIR}/output/Platinum Report.pdf"
    rescue
      puts "Unable to generate Platinum Report"
    end
    
  end
  
end




module Report::GeneralMiningReport 
  def header
    #Set parameters for the heading
    title_options = {:at => [0, 819], :size => 13, :style => :bold}
    caption_options = {:at => [0, 809], size: 8}
    date_text_options = {:at => [172, 819], :size => 8, :style => :bold}
    
    global_section_heading_options = {:at => [0, 793], :size => 10}
    general_section_heading_options = {:at => [@general_left, 793], :size => 10}
    image_heading_options = {:at => [510, 832], :width => 70}
    header_line_y = 790
    
    header = self.extend(Report).header_template(title_options, caption_options, date_text_options, global_section_heading_options, general_section_heading_options, image_heading_options, header_line_y)
  end
  
  
  def global_section
    global_section_height = 130
    global_section_bottom_line = 660
    
    global_section = self.extend(Report).global_section_template(global_section_height, global_section_bottom_line)
  end
  
  
  def main_content
		#Add Column format
		self.column_box([0, 650], :columns => 2, :width => self.bounds.width, :height => 630, :overflow => :truncate) do
			position = {'0' => self.cursor}
			col = 1
      									
			#METAL ORES HEADING 
			heading("METAL ORES", self, @main_heading_break, @main_content_heading_format)			
					
			#Iron ore
      draw_price_point(col, self, @prices, :iron_ore, 13)
			draw_stories(self, @after_price_break, @section_break, @stories_format, @iron_ore_stories)   
			

      #Manganese ore
      position = check_position(position, '1', self)
			col = 2 if position['1'] - position['0'] > 0
			draw_price_point(col, self, @prices, :manganese, 13)
			draw_stories(self, @after_price_break, @section_break, @stories_format, @manganese_ore_stories)

			#Chrome ore
      position = check_position(position, '2', self)
			col = 2 if position['2'] - position['1'] > 0
      draw_price_point(col, self, @prices, :chrome, 13)
			draw_stories(self, @after_price_break, @section_break, @stories_format, @chrome_ore_stories)
      
      #PRECIOUS METALS HEADING
      position = check_position(position, '3', self)
			col = 2 if position['3'] - position['2'] > 0
			heading("PRECIOUS METALS", self, @main_heading_break, @main_content_heading_format)
			

      #Gold	
      draw_price_point(col, self, @prices, :gold, 13)
			draw_stories(self, @after_price_break, @section_break, @stories_format, @gold_stories)
      
      
      
			#Platinum & Palladium Heading
      position = check_position(position, '4', self)
			col = 2 if position['4'] - position['3'] > 0
			heading("Platinum & Palladium", self, @main_heading_break, @sub_content_heading_format)	


			#PGM
			draw_price_point(col, self, @prices, :platinum, 13)
      position = check_position(position, '5', self)
			col = 2 if position['5'] - position['4'] > 0
			draw_price_point(col, self, @prices, :palladium, 13)
			draw_stories(self, @after_price_break, @section_break, @stories_format, @pgm_stories)

			#Diamonds	
			position = check_position(position, '6', self)
			col = 2 if position['6'] - position['5'] > 0
      draw_price_point(col, self, @prices, :diamonds, 13)		
			draw_stories(self, @after_price_break, @section_break, @stories_format, @diamonds_stories)
			
			#BASE METALS HEADING
			position = check_position(position, '7', self)
			col = 2 if position['7'] - position['6'] > 0
			heading("BASE METALS", self, @main_heading_break, @main_content_heading_format)		
			

			#Copper
      draw_price_point(col, self, @prices, :copper, 13)	
			draw_stories(self, @after_price_break, @section_break, @stories_format, @copper_stories)			
      
      #Aluminium	
			position = check_position(position, '8', self)
			col = 2 if position['8'] - position['7'] > 0
      draw_price_point(col, self, @prices, :aluminium, 13)
			draw_stories(self, @after_price_break, @section_break, @stories_format, @aluminium_stories)
      
      
      #Nickel	
			position = check_position(position, '9', self)
			col = 2 if position['9'] - position['8'] > 0
			draw_price_point(col, self, @prices, :nickel, 13)	
			draw_stories(self, @after_price_break, @section_break, @stories_format, @nickel_stories)
			
      
      #ENERGY COMMODITIES HEADING
			position = check_position(position, '10', self)
			col = 2 if position['10'] - position['9'] > 0		
			heading("ENERGY COMMODITIES", self, @main_heading_break, @main_content_heading_format)		
      
			#Coal	
      draw_price_point(col, self, @prices, :coal, 13)			
			draw_stories(self, @after_price_break, @section_break, @stories_format, @coal_stories)
      
      #Oil & Gas Heading
			position['11'] = self.cursor
			col = 2 if position['11'] - position['10'] > 0
			position = check_position(position, '11', self)
			col = 2 if position['11'] - position['10'] > 0
			heading("Oil & Gas", self, @main_heading_break, @sub_content_heading_format)		
			
			#Oil & Gas		
			draw_price_point(col, self, @prices, :oil, 13)	
			position = check_position(position, '12', self)
			col = 2 if position['12'] - position['11'] > 0
			draw_price_point(col, self, @prices, :gas, 13)
      draw_stories(self, @after_price_break, @section_break, @stories_format, @oil_gas_stories)
			
      #Uranium	
			position = check_position(position, '13', self)
			col = 2 if position['13'] - position['12'] > 0
			draw_price_point(col, self, @prices, :uranium, 13)
			draw_stories(self, @after_price_break, @section_break, @stories_format, @uranium_stories)
		end
		
		########## Middle Line ##########
		self.stroke do
			self.vertical_line 25, 650, :at => 293
			self.line_width = 0.05
		end
  end
  
   
  def footer
    footer = self.extend(Report).footer_template
  end
  
end



module Report::EnergyReport
  def header
    #Set parameters for the heading
    title_options = {:at => [0, 819], :size => 13, :style => :bold}
    caption_options = {:at => [0, 809], size: 8}
    date_text_options = {:at => [172, 819], :size => 8, :style => :bold}
    
    global_section_heading_options = {:at => [0, 793], :size => 10}
    general_section_heading_options = {:at => [@general_left, 793], :size => 10}
    image_heading_options = {:at => [510, 832], :width => 70}
    header_line_y = 790
    
    header = self.extend(Report).header_template(title_options, caption_options, date_text_options, global_section_heading_options, general_section_heading_options, image_heading_options, header_line_y)
  end
  
  def content
    puts "working"
  end
  
  def footer
    footer = self.extend(Report).footer_template
  end
end



module Report::PlatinumReport
  def header
    #Set parameters for the heading
    title_options = {:at => [0, 819], :size => 13, :style => :bold}
    caption_options = {:at => [0, 809], size: 8}
    date_text_options = {:at => [172, 819], :size => 8, :style => :bold}
    
    global_section_heading_options = {:at => [0, 793], :size => 10}
    general_section_heading_options = {:at => [@general_left, 793], :size => 10}
    image_heading_options = {:at => [510, 832], :width => 70}
    header_line_y = 790
    
    header = self.extend(Report).header_template(title_options, caption_options, date_text_options, global_section_heading_options, general_section_heading_options, image_heading_options, header_line_y)
  end
  
  def content
  end
  
  def footer
    footer = self.extend(Report).footer_template
  end
end

	
