require 'rest-client'
require 'mechanize'
require 'nokogiri'
require 'open-uri'

namespace :db do
  desc "Scrapes data from Comic Strip Library and adds it to the database"
  task :populate => :environment do
    
    #Set up basic variables
    BASE_URL = "http://www.comicstriplibrary.org/browse/" 
    URL = "#{BASE_URL}results?title=2" #specific to Little Nemo 

    # test urls
    test_url1 = 'http://www.comicstriplibrary.org/display/152' #standard: no notes, transcript, or summary
    test_url2 = 'http://www.comicstriplibrary.org/display/565' #with transcript
    test_url3 = 'http://www.comicstriplibrary.org/display/1017' #with notes and summary
    
    
    def entryMaker(url)

        # set up for image links
        img_base = "http://www.comicstriplibrary.org"

        curPage = Nokogiri::HTML(open(url))

        curEntry = {}
        curTable = curPage.css("table#metadata") 

        # regexes strip id and stores it.
        foundID = url.match(/\/(\d+)/).to_s
        foundID.gsub!(/\//,'')
        curEntry['comic_id'] = foundID
        puts "I.D. added! it is #{foundID}"
        
        curTable.css("tr").each do |row|
            case row.css('th').text

            when "Title"
                curEntry['title'] = row.css('td').text.strip

            when "Author"
                curEntry['author'] = row.css('td').text.strip

            when "Date Published"
                cleaned_row = row.css('td').text.strip
                rawDate = cleaned_row.gsub(/^(\d{4})-(\d{2})-(\d{2})\s-\s([a-zA-Z]+)/,'\4, \2-\3-\1')
                simpleDate = cleaned_row.gsub(/^(\d{4})-(\d{2})-(\d{2})\s-\s([a-zA-Z]+\s)/,'\2-\3-\1')

                # for a friendlier date string
                curEntry['date_display'] = rawDate

                # standardized dates, to be sorted against
                begin
                    parsedDate = Date.parse(simpleDate)
                    curEntry['date_published'] = parsedDate
                rescue StandardError => e
                    yearOnly = rawDate.match(/\d{4}$|\d{4}\s$/)
                    curEntry['date_published'] = yearOnly
                    next
                end

                # curEntry['date_published'] = parsedDate

            when "Summary"
                curEntry['summary'] = row.css('td').text.strip

            when "Characters"
                cleaned_row = row.css('td').text.strip
                cleaned_row.gsub!(/\n\s+|\n/, "")
                curEntry['characters'] = cleaned_row.split(',').collect(&:strip) 

            when "Contents"
                cleaned_row = row.css('td').text.strip
                cleaned_row.gsub!(/\n\s+|\n|\_\(\d+\)/, "")
                cleaned_row.gsub!(/\_/," ")
                curEntry['contents'] = cleaned_row.split(',').collect(&:strip) 

            when "Notes"
                curEntry['notes'] = row.css('td').text.strip

            when "Transcript"
                if row.text.match(/transcribe/)
                    curEntry['transcript'] = false
                else
                    curEntry['transcript'] = true
                    curEntry['transcript_text'] = row.css('td').text.strip
                end

            end

        end


        this_img = curPage.css("#display-wrapper img").map { |link| link["src"] }[0]
        img_url = img_base + this_img

        # add standard img link
        curEntry['img'] = img_url

        # add smaller/thumb img link
        thumb = img_url.gsub(/-s/,"-tn")
        curEntry['img_thumb'] = thumb

        # add hi-res img link
        hiRes = img_url.gsub(/-s/,"-l")
        curEntry['img_link'] = hiRes

        return curEntry
    end

    
    pageLinks = [] #Set up empty array
    count = 0 # Sets up top-level error count 
    inner_count = 0 # Sets up second-level error count 

    #Puts every page link into an array 
    22.times do |ind|
        pageLinks << "#{BASE_URL}results?title=2&page=#{ind+1}"
    end

    pageLinks.each do |link|

        begin
            pg = Nokogiri::HTML(open(link))
            allComics = pg.css("div.result a").map { |link| link['href'] }
            
            begin 
                allComics.each do |lnk|
                    comic = "http://www.comicstriplibrary.org/#{lnk}"
                    obj = entryMaker(comic)

                    # CREATE NEW ENTRY, PASSING IN THE ENTRYMAKER OBJECT
                    saved_comic = Comic.new()

                    obj.each do |key, value|
                        saved_comic[key] = value
                    end

                    saved_comic.save!
                    puts "All values saved! Added new object successfully."
                    # puts obj['date_published']
                end

                sleep 2

            rescue StandardError => f
                inner_count += 1
                puts "---------------------"
                puts "Fail Number: #{inner_count} "
                puts "Fail Reason: #{f}"
            end
            
            
        rescue StandardError => e
            count += 1
            puts "--------------------------------------------"
            puts "Fail Number: #{count} "
            puts "Fail Reason: #{e}"
            
        end
        
    end
    
    
  end
end