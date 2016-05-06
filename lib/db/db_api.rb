class DB
    def initialize(host, username, password, database, data)
        @host = host
        @username = username
        @password = password
        @database = database
        @data = data
    end

    def add_to_mysql_db
        begin
            db = Mysql2::Client.new(:host => @host, :username => @username, :password => @password, :database => @database)
            success = true
        rescue
            puts "ERROR: Unable to connect to MySQL database"
            success = false
        end

        if success
            @data.each do |k,v|
                v.each do |c|

                    commodity = k.to_s.sub("_", " ").capitalize
                    if commodity == "Oil gas"
                        commodity = "Oil & Gas"
                    end

                    #Year-month-day
                    date = Date.strptime("2015-05-25")

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



# TODO: Instructions for adding to an Access Database
