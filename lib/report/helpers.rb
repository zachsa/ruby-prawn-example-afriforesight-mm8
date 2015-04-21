


def draw_stories(pdf, section_break, stories_format, stories)
	stories.each do |s|
		pdf.text(s, stories_format)
	end
	pdf.move_down section_break
end


def heading(txt, pdf, main_heading_break, format)
	pdf.fill_color "6E2009"
	pdf.font 'Arial Narrow', :style => :bold_italic
	pdf.text(txt, format)
	pdf.font 'Arial Narrow', :style => :normal
	main_heading_break	
end



def check_position(positions, position, pdf)
  if pdf.cursor < 20
    pdf.move_down 20
    pdf.text(' ')
    positions[position] = pdf.cursor
  else
    positions[position] = pdf.cursor
  end
  positions
end