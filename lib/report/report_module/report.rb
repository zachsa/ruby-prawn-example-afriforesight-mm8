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
end