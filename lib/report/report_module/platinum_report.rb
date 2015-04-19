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