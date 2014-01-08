module GalleryHelper

	def dater(date)
		if date.class === nil
			date = "1905-00-00"
		end
		return date
	end
end
