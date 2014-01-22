require 'rest-client'
require 'open-uri'

namespace :export do
	desc "Generates json from database and saves to a separate file"
	task :as_json => :environment do

		fname = "db/comic_data.json"
		comicData = Comic.all
		jsonData = comicData.to_json

		jFile = File.open(fname, "w")
		jFile.puts jsonData
		jFile.close

	end
end