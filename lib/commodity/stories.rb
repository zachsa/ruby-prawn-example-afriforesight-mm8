class StoriesJSON
	attr_accessor :content, :content_for_db

	def find_word_file
		txt = ""
		Dir.entries(BASEDIR).each do |i|
			txt = i if i[/docx/]
		end
		txt
	end

	def initialize
		file = find_word_file
    
    	multi_line_break = /\\n\s+\\n/
    	single_line_break = "\\n"    
    	#story_break = multi_line_break
    	story_break = single_line_break
		
		begin
			content = Docx::Document.open(file)
			content = content.to_html
			content = content.gsub("–", "-")			

		rescue
			puts "Problem reading the docx file: Class StoriesJSON, initialize"
			exit
		end
		
		begin
			content = Sanitize.fragment(content, {:elements => ['strong']})
		rescue
			puts "Problem with Sanitize gem"
			exit
		end
		
		begin
			content = split_content(content, story_break)
		rescue
			puts "Problem splicing stories with Regex"
			exit
		end

		content = remove_empty_stories(content)
    	content = remove_double_spaces_and_newlines(content)
		content = split_stories_by_country(content)

		@content_for_db = Marshal.load(Marshal.dump(content))

		content = make_country_bold(content)		
		@content = join_formatted_data(content)    
    
	end
	

	
	def join_formatted_data(arr)
		arr.clone.each do |commodity, stories|
			for i in 0...stories.length do
				arr[commodity][i] = arr[commodity][i].join(" - ")
			end
		end
	end
	

	
	
	def make_country_bold(arr)
		arr.clone.each do |commodity, stories|
			for i in 0...stories.length do
				txt = "<b>#{arr[commodity][i][0]}</b>"
				arr[commodity][i][0] = txt
			end
		end
		arr
	end
	


	def remove_empty_stories(content)
    new_content = {}
    
		content.each do |section,stories|
      new_content[section] = []
      
			for i in 0...stories.length do
				unless stories[i].length < 25
          new_content[section] << stories[i]
				end
			end
		end
    
		new_content
	end


	def split_stories_by_country(content)
		#content needs to be clean data at this point
		
		#Function splits between country and story to allow for further formatting
		#Function breaks without a country entry
		
		#Clones the argument hash for easier debugging
		content_copy = Marshal.load(Marshal.dump(content))

		content.clone.each do |comm, stories|
			for i in 0...stories.count do
				
				begin
					content[comm][i]
					content[comm][i] = content[comm][i].sub("-", "<SPLIT HERE>").split("<SPLIT HERE>")
					content[comm][i][0].rstrip!
					content[comm][i][0].lstrip!
					content[comm][i][1].rstrip!
					content[comm][i][1].lstrip!
				rescue
					puts
					ap content_copy
					puts
					puts 'ERROR:'
					puts "Trying to split #{comm} at story No. #{i} - preceded by the story: #{content[comm][i-1]}"
				end
		
				begin
					if content[comm][i].count != 2
						raise 
					end
				rescue Exception
					puts ('Formatting error: check source DocX file. Each story needs a country entry')
					puts 'Exiting....'
					exit
				end
			end
		end
		
		content
	end
	
	def remove_double_spaces_and_newlines(content)
    content.each do |section, stories|
      stories.each do |story|
        story.gsub!("\\n", '')
        story.gsub!(/[ ]{2,}/, ' ')
      end
    end
  end
	
	
	def split_content(content, story_break)
    
    possible_sections = {
      :GENERAL_STORIES => :general_stories,
      :IRON_STORIES => :iron_ore,
      :MANGANESE_STORIES => :manganese_ore,
      :CHROME_STORIES => :chrome_ore,
      :GOLD_STORIES => :gold,
      :PGM_STORIES => :pgm,
      :DIAMONDS_STORIES => :diamonds,
      :COPPER_STORIES => :copper,
      :ALUMINIUM_STORIES => :aluminium,
      :NICKEL_STORIES => :nickel,
      :COAL_STORIES => :coal,
      :OIL_GAS_STORIES => :oil_gas,
      :URANIUM_STORIES => :uranium
    }
    
    #NOTE: This method assumes that there are no underscores in normal text
    sections = content.scan(/\b\w+?_\w+\b/)
    

    mm8 = {}
    for i in 0...sections.length do
      begin
        mm8[sections[i].to_sym] = content[/#{sections[i]}.*#{sections[i+1]}/m].gsub(sections[i], '')
        mm8[sections[i].to_sym].gsub!(sections[i + 1], '') if i < sections.length - 1
        mm8[sections[i].to_sym] = mm8[sections[i].to_sym].split(story_break)
      rescue
        puts "Unable to spice stories (sorry it's such a high level error for now)"
        exit
      end
    end

    mm8.clone.each do |comm,arr|
    	arr.each do |story|
    		if story.length < 10
    			mm8[comm].delete(story)
    		end
    	end
    end

    mm8.clone.each do |k, v|
      new_key = possible_sections[k]
      mm8[new_key] = mm8.delete(k)
    end
    
		mm8
	end

end