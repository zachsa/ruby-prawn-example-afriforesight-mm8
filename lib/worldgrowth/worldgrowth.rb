class WorldGrowth
    attr_accessor :content
    def initialize
        #Loads a word file with the World Growth Section
        file = find_word_file
        content = load_file(file)
        content = format_content(content)
        @content = content
    end

    def format_content(content)
        content = Sanitize::fragment(content, {:elements => ['p', 'strong']})
        content = content.split('\n')
        content.delete_if { |i| i.length < 10 }

        content = content.each.map { |i| Sanitize::fragment(i, :elements => ['strong']) }
        content = content.each.map { |i| i.gsub('<strong>', '<b>') }
        content = content.each.map { |i| i.gsub('</strong>', '</b>') }
        content.each { |i| i.strip! }

        content
    end

    def load_file(file)
        content = Docx::Document.open("#{BASEDIR}/lib/worldgrowth/#{file}").to_html
        content
    end

    def find_word_file
        txt = ""
        Dir.entries("#{BASEDIR}/lib/worldgrowth").each do |i|
            txt = i if i[/docx/]
        end
        txt
    end
end