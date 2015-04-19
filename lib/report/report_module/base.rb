module Report
end

class Report::Base < Prawn::Document
  #Initializes the document parameters and content instances
  #Creates the Prawn document
  def initialize(world_growth, commodity_news, prices, date_period, world_growth_font_size, general_stories_font_size, content_font_size, default_prawn_options)
  
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
    set_up_general_attributes
  end
  
  
  def set_up_general_attributes
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
  
  
  def global_section_template(global_section_height, global_section_bottom_line, content_y)
		#World Overview
		self.bounding_box([0, content_y], :width => (self.bounds.right/2 - 3), :height => global_section_height) do
			self.text(@world_growth, @world_overview_format)
			self.move_down 2
			self.text(@prices[:baltic], size: 6.9, :inline_format => true, :style => :bold)
		end
		#General Stories
		self.bounding_box([@general_left, content_y], :width => (self.bounds.right/2 - 9), :height => global_section_height) do
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
  
  
  def generate_report(title)
    begin
      header
      global_section
      main_content
      footer
      self.render_file "#{BASEDIR}/output/#{title}.pdf"
    rescue
      puts "Unable to generate #{title}"
      exit
    end
  end
  
  
end

































