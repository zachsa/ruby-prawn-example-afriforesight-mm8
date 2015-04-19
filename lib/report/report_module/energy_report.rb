module Report::EnergyReport
  def header
    #Set parameters for the heading
    title_options = {:at => [0, 819], :size => 13, :style => :bold}
    caption_options = {:at => [0, 809], size: 8}
    date_text_options = {:at => [172, 819], :size => 8, :style => :bold}
    
    global_section_heading_options = {:at => [0, 773], :size => 10}
    general_section_heading_options = {:at => [@general_left, 773], :size => 10}
    image_heading_options = {:at => [510, 832], :width => 80}
    header_line_y = 770
    
    header = self.extend(Report).header_template(title_options, caption_options, date_text_options, global_section_heading_options, general_section_heading_options, image_heading_options, header_line_y)
  end
  
  def global_section
    global_section_height = 130
    global_section_bottom_line = 480
    content_y = 767
    
    global_section = self.extend(Report).global_section_template(global_section_height, global_section_bottom_line, content_y)
  end
  
  def main_content
  end
  
  def footer
    footer = self.extend(Report).footer_template
  end
end