def add_to_db
	db = Mysql2::Client.new(:host => "localhost", :username => "root", :password => 'password', :database => 'mm8')

	data.each do |k,v|
		v.each do |c|
			commodity = k.to_s.sub("_", " ").capitalize
			if commodity == "Oil gas"
				commodity = "Oil & Gas"
			end
		
			date = Date.strptime("2015-03-09")
		
			country = c[0]
			story = c[1]
		
		
			sql = "INSERT INTO stories SET
					Date = \"#{date}\",
					Category = 'mm8',
					Country = \"#{country}\",
					Commodity = \"#{commodity}\",
					Text = \"#{story}\";"
		
			db.query(sql)
		end
	end
end
