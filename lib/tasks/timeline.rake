require 'date'

task :timeline => :environment do


	years = [1905,1906,1907,1908,1909,1910,1911,1912,1913,1914]
	comicData = Comic.ordered.limited.all
	comicYears = []
	contentsArray = []

	def runYears(data, arr, years)
		sYears = years.map{ |yr| yr.to_s }

		data.each do |strip|
			year = strip["date_display"].split("-")[-1]
			arr << year
		end

		arr.each do |yr|
			puts yr
		end
	end

	def gatherThemes(data, arr, years)
		data.each do |strip|
			year = strip["date_display"].split("-")[-1]
			contents = strip["contents"]

			if contents.length > 1 
				contents.each do |cont|
					hsh = { "year" => year, "name" => cont }
					arr << hsh
				end
			else 
				hsh = { "year" => year, "name" => contents[0] }
				arr << hsh
			end
		end

		# puts arr.length
		
		c = Hash.new(0)

		arr.each do |v|
			c[v] += 1
		end	

		arrC = c.to_a
		arrTrim = arr.uniq

		arrTrim.zip(arrC).each do |trim, num|

			if trim["name"] == num[0]["name"]
				trim["count"] = num[1]
			end
		end

		arrFull = []

		arrTrim.each do |tr|

			years.each do |yr|
				tmpHsh = {
					"year" => yr.to_s,
					"name" => tr["name"],
					"count" => "0"
				}

				if tmpHsh["year"] == tr["year"] && tmpHsh["name"] == tr["name"] && !tmpHsh["exists"]
					tmpHsh["count"] = tr["count"]
					tmpHsh["exists"] = true
				else
					tmpHsh["exists"] = false
				end

				if tmpHsh["exists"] != false
					arrFull << tmpHsh
				end
			end

		end

		# arrFull.uniq.sort_by{ |v| v["year"] }.group_by{ |w| w["name"] }.each do |key, grp|
		# 	grp.each{ |itm| puts itm }
		# end

		arrFull.uniq.each do |term|
			if term["name"] == "Falling"
				puts "\'#{term['name']}\', occurred #{term['count']} times in #{term['year']}"
			end
		end

		# b = arr.inject(Hash.new(0)) {|h,i| h[i] += 1; h }
		# b.sort_by{|key, value| value}.to_a.each do |label,count| 
		# 	if count > 9
		# 		puts "#{label}: #{count}" 
		# 	end
		# end
	end
	
	gatherThemes(comicData, contentsArray, years)
	#runYears(comicData, comicYears, years)
	

end