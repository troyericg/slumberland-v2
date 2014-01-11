class Comic < ActiveRecord::Base
	scope :ordered, :order => 'date_published asc'
	scope :limited, :limit => 100

	attr_accessible :author, :characters, :contents, :date_display, :date_published, :img, :img_link, :img_thumb, :notes, :summary, :title, :transcript, :transcript_text
	serialize :characters
	serialize :contents

end
