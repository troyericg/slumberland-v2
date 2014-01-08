require 'rest-client'
require 'open-uri'

namespace :db do
	desc "Putting data in the database"
	task :makejson => :environment do

		fname = "db/comic_data.json"
		comicData = Comic.all
		jsonData = comicData.to_json

		jFile = File.open(fname, "w")
		jFile.puts jsonData
		jFile.close

	end
end