require 'date'

namespace :setup do

	desc "[In Development] Populates a separate table of timeline data"
	task :get_timeline => :environment do
		puts 
		puts "---------------------"
		puts "NOTE: This will eventually build and populate a separate table for the timeline data"
		puts "---------------------"
		puts 
	end



	# -------------------------------------------------------------------- #



	desc "Creates a proper count of occurences across years"
	task :test_timeline => :environment do

		arg_term = ARGV.last
		task arg_term.to_sym do ; end

		years = [1905,1906,1907,1908,1909,1910,1911,1912,1913,1914]
		comicData = Comic.ordered.limited.all # data from database 
		comicYears = [] # stores initial list of years 
		contentsArray = [] # stores initial comic data hashes 
		arrFull = [] # for hashes that have count values 
		arrBig = [] # for full array of hashes
		test_terms = [
			"sunrises & sunsets", # 0
			"race discrimination", # 1
			"falling", # 2
			"costumes", # 3
			"forests", # 4
			"decapitations", # 5
			"ethnic stereotypes", # 6
			"gems", # 7
			"crying", # 8
			"candy", # 9
			"marching bands", # 10
			"sailors" # 11
		]

		comicData.each do |strip|
			year = strip["date_display"].split("-")[-1]
			contents = strip["contents"]

			if contents.length > 1 
				contents.each do |cont|
					hsh = { "year" => year, "name" => cont }
					contentsArray << hsh
				end
			else 
				hsh = { "year" => year, "name" => contents[0] }
				contentsArray << hsh
			end
		end

		
		c = Hash.new(0)

		contentsArray.each do |v|
			c[v] += 1
		end

		arrC = c.to_a
		arrTrim = contentsArray.uniq

		arrTrim.zip(arrC).each do |trim, num|

			if trim["name"] == num[0]["name"]
				trim["count"] = num[1]
			end
		end

		# creates the hashes and adds them to the 2 arrays, one for counted terms and one for all terms
		arrTrim.each do |tr|

			years.each do |yr|
				tmpHsh = {
					"year" => yr.to_s,
					"name" => tr["name"],
					"count" => "0",
					"exists" => false
				}

				if tmpHsh["year"] == tr["year"] && tmpHsh["name"] == tr["name"] && tmpHsh["exists"] != true
					tmpHsh["count"] = tr["count"]
					tmpHsh["exists"] = true
				end

				if tmpHsh["exists"] != false
					arrFull << tmpHsh
					arrBig << tmpHsh
				else 
					arrBig << tmpHsh
				end
			end
		end

		#goes over full array and deletes duplicate items
		arrFull.each do |counted_item|
			arrBig.delete_if do |item|
				item["year"] == counted_item["year"] && item["name"] == counted_item["name"] && item["count"].to_i < counted_item["count"].to_i
			end
		end

		# sorts the final array and outputs items based on search term
		arrBig.uniq.sort!{ |a,b| a["year"] <=> b["year"] }.each do |term|
			
			if term["name"].downcase == arg_term
				puts "\'#{term['name']}\', occurred #{term['count']} times in #{term['year']}."
			end
		end

	end

end