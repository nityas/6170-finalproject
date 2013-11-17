class Location < ActiveRecord::Base
	geocoded_by :address
	after_validation :geocode, :if => :address_changed?
	has_many :offerings, dependent: :destroy

	def get_or_create_id(location) 
		if !Location.exists?(customid: location.customid)
			newlocation = Location.new(location)
			newlocation.save()
			locationid = newlocation.id
		else
			locationid = Location.where(:customid => location.customid).id
		end
		return locationid
	end
end
