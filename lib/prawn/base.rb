module Report
end

class Report::Base < Prawn::Document
  #Initializes the document parameters and content instances
  #Creates the Prawn document
  def initialize(world_growth, commodity_news, prices, date_period, world_growth_font_size, general_stories_font_size, content_font_size, default_prawn_options)
      
    #General variables
    @date_period = date_period
    @world_growth = world_growth
    @prices = Marshal.load(Marshal.dump(prices))
  
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
  	@general_stories_format = {:size => @general_stories_font_size, :align => :justify, :inline_format => true, :indent_paragraphs => -1, :leading => 0.2}
  	@world_overview_format = {:size => @world_growth_font_size, :align => :justify, :inline_format => true}
    
    #Main content formatting
  	@stories_format = {:size => @content_font_size, :align => :justify, :inline_format => true, :indent_paragraphs => -1, :leading => 0.2}
    
    #Headings formats
  	@main_content_heading_format = {:size => 9, :indent_paragraphs => 4}
  	@sub_content_heading_format = {:size => 8, :indent_paragraphs => 4}
    
    #Breaks formats
  	@main_heading_break = 2
  	@section_break = 3
  	@after_price_break = 0 # Defined in sub classes for each report
    
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
    font('Arial Narrow')
  end
  
  
  
  def header_template(title_options, caption_options, date_text_options, global_section_heading_options, general_section_heading_options, image_heading_options, header_line_y)
		draw_text("MONDAY MORNING MINING @ 8", title_options)
		draw_text('This page updates you quickly on key developments relating to mining and extraction over the last week and this Monday afternoon in Asia', caption_options)
		draw_text(@date_period, date_text_options)
		
		fill_color @brown
		draw_text('GLOBAL ECONOMIC DEVELOPMENT', global_section_heading_options)
		draw_text('GENERAL MINING STORIES', general_section_heading_options)
		image "#{BASEDIR}/lib/images/logo.png", image_heading_options
	  
    stroke_color @brown
		stroke do
			horizontal_line 0, (bounds.right/2 - 3), :at => header_line_y
			horizontal_line @general_left, @general_right, :at => header_line_y
			self.line_width = 0.05
		end
  end
  
  
  
  
  
  def global_section_template(global_section_height, global_section_bottom_line, content_y, global_leading)
		
    #World Overview
		bounding_box([0, content_y], :width => (bounds.right/2 - 3), :height => global_section_height) do
      move_down global_leading
      for i in 0...@world_growth.length do
        text(@world_growth[i], @world_overview_format)
			  move_down 2.5
      end
		end
    
		#General Stories
		bounding_box([@general_left, content_y], :width => (bounds.right/2 - 9), :height => global_section_height) do
			move_down global_leading
      @general_stories.each do |s|
				indent(1) do
          text(s, @general_stories_format)
          move_down 0
        end
			end
		end
    
    stroke_color @brown
		stroke do
			horizontal_line 0, bounds.right, :at => global_section_bottom_line
			self.line_width = 0.05
		end
    
    fill_color '000000'
  end
  
  
  def footer_template
    fill_color @brown
		stroke do
			horizontal_line 0, bounds.right, :at => 20
			self.line_width = 0.05
		end
    fill_color '000000'
		move_down 5
		text('Disclaimer: The publication’s content is confidential and only for the use of the recipient and remains proprietary to Afriforesight . You may not copy or distribute this document without our written consent. The writers work fast to get the info to you asap and we can make no warranties in respect of accuracy. Any forecast made is just the writer’s best guess and we strongly advise you not to take any risky decisions on them.', :size => 6)
  end
  
  
  
  
  
  def generate_report(title)
    begin
      header
    rescue
      puts "ERROR: problem drawing the header (#{title} report)"
      exit
    end
    
    begin
      global_section
    rescue
      puts "ERROR: problem drawing the global section (#{title} report)"
      exit
    end
    
    begin
      main_content
    rescue
      puts "ERROR: problem drawing the main content section (#{title} report)"
      exit
    end
    
    begin
      footer
    rescue
      puts "ERROR: problem drawing the footer (#{title} report)"
      exit
    end
    
    begin
      if File.directory?("#{BASEDIR}/output") == false
        Dir.mkdir("#{BASEDIR}/output")
      end
      render_file "#{BASEDIR}/output/#{title}.pdf"
    rescue
      puts "Unable to generate the #{title} pdf"
      exit
    end
  end
  
  def draw_stories(section_break, stories_format, stories)
    stories.each do |s|
        indent(1) do
          text(s, stories_format)
          move_down 0
      end
    end
    move_down section_break
  end
  
  def heading(txt, main_heading_break, format)
    fill_color "6E2009"
    font 'Arial Narrow', :style => :bold_italic
    text(txt, format)
    font 'Arial Narrow', :style => :normal
    main_heading_break  
  end
  
  def draw_price_point(col, prices, comm, price_point_size, vertical_padding)  
    #Sets the margin depending on which column is being drawn
  	left_margin = 298
  	if col == 2 
  		x = left_margin
  	else
  		x = -0.5
  	end
    #Creates a bounding box for the rectangle and the text
    bounding_box([x, cursor], :width => 288, :margin => [0, 0]) do
      #1st creates a coloured rectangle
      fill_and_stroke do
        rectangle([0, cursor], 288, price_point_size)
        fill_color @brown
        stroke_color @white
      end
      #Adds text on top of the box
      fill_color(@white)
  		move_down vertical_padding
  		text(prices[comm], :indent_paragraphs => 4, :inline_format => true, :style => :bold)
      fill_color(@black)
    end
  end
  
  
  def check_position(positions, position)
    if self.class.to_s == 'Report::GeneralReport'
      box_height = 20
    elsif self.class.to_s =="Report::EnergyReport"
      box_height = 38
    elsif self.class.to_s =="Report::PlatinumReport"
      box_height = 38
    end
    
    if cursor < box_height
      move_down box_height
      text(' ')
      positions[position] = cursor
    else
      positions[position] = cursor
    end
    positions
  end
  
  
end

































