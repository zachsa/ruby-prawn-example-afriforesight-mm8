require 'Mysql2'
require 'win32ole'



def add_to_db(data)
	db = Mysql2::Client.new(:host => "localhost", :username => "root", :password => 'pfnafn1', :database => 'afriforesightresearch')



	data.each do |k,v|
		v.each do |c|
			commodity = k.to_s.sub("_", " ").capitalize
			if commodity == "Oil gas"
				commodity = "Oil & Gas"
			end
		
			date = Date.strptime("2015-03-09")
		
			country = c[0]
			story = c[1]

		
			sql = "REPLACE INTO mm8 SET
					story_date = \"#{date}\",
					Category = 'mm8',
					Country = \"#{country}\",
					Commodity = \"#{commodity}\",
					story_text = \"#{story}\",
					unique_text = MD5(\"#{story}\");"

			db.query(sql)

		end
	end
end

=begin
CREATE TABLE MM8 (
id INT(99) NOT NULL AUTO_INCREMENT PRIMARY KEY,
story_date DATE NOT NULL,
category VARCHAR(30) NOT NULL,
country VARCHAR(30) NOT NULL,
commodity VARCHAR(30) NOT NULL,
story_text TEXT(500) NOT NULL,
unique_text VARCHAR(100) UNIQUE
);
=end



#Instructions for adding to an Access Database