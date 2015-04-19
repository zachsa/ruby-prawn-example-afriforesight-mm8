def draw_price_point(col, pdf, prices, comm, box_height)
	left_margin = 298.5
	if col == 2 
		x = left_margin
	else
		x = 0
	end
	pdf.bounding_box([x-1, pdf.cursor], :width => 287, :height => box_height) do
		pdf.stroke_color "6E2009"
		pdf.stroke do
			pdf.fill_color "6E2009"
			pdf.fill_and_stroke_rounded_rectangle [pdf.cursor - 12,pdf.cursor], 287, box_height, 0
			pdf.fill_color 'FFFFFF'
		end
		pdf.move_down 3.3
		pdf.text(prices[comm], size: 6.9, :indent_paragraphs => 4, :inline_format => true, :style => :bold)
		pdf.fill_color '000000'
	end
end


def draw_stories(pdf, after_price_break, section_break, stories_format, stories)
	pdf.move_down after_price_break
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