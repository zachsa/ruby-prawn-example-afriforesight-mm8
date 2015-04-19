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
  
  def generate_general_report
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
  end
  
  def generate_energy_report
    #Energy report
    begin
      energy_report = self
      energy_report.extend(Report::EnergyReport)
      energy_report.header
      energy_report.global_section
      energy_report.main_content
      energy_report.footer
      energy_report.render_file "#{BASEDIR}/output/Energy Report.pdf"
    rescue
      puts "Unable to generate Energy Report"
      exit
    end
  end
  
  def generate_platinum_report
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