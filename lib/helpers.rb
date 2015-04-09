def find_word_file
	txt = ""
	Dir.entries(BASEDIR).each do |i|
		txt = i if i[/docx/]
	end
	txt
end


def find_excel_file
	txt = ""
	Dir.entries(BASEDIR).each do |i|
		txt = i if i[/xlsx/]
	end
	txt
end