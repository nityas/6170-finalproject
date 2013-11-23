class Location < ActiveRecord::Base
	has_many :offerings, dependent: :destroy

	#get a locaion id if the location already exists in the location table. Otherwise, creates the location
	#@param - given a location object
	# return the location id
	def self.get_or_create_id(location) 
		if !Location.exists?(customid: location.customid)
			newlocation = Location.new(location)
			newlocation.save()
			locationid = newlocation.id
		else
			locationid = Location.where(:customid => location.customid).first.id
		end
		return locationid
	end

end


    
