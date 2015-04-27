require 'Mysql2'

def add_to_db(data)
	db = Mysql2::Client.new(:host => "localhost", :username => "root", :password => 'pfnafn1', :database => 'afriforesightresearch')


	data.each do |k,v|
		puts v
		v.each do |c|
			commodity = k.to_s.sub("_", " ").capitalize
			if commodity == "Oil gas"
				commodity = "Oil & Gas"
			end
		
			date = Date.strptime("2015-03-09")
		
			country = c[0]
			story = c[1]
		
		
			sql = "INSERT INTO mm8 SET
					Date = \"#{date}\",
					Category = 'mm8',
					Country = \"#{country}\",
					Commodity = \"#{commodity}\",
					story_text = \"#{story}\";"

		
			#db.query(sql)

		end
	end
end
