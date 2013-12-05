class Location < ActiveRecord::Base
	has_many :offerings, dependent: :destroy
	has_many :subscriptions#, dependent: :destroy


	#get a locaion id if the location already exists in the location table. Otherwise, creates the location
	#@param - given a location object
	# return the location id
	def self.get_or_create_id(location) 
		if !Location.exists?(customid: location.customid)
			location.save()
			locationid = location.id
		else
			locationid = Location.where(:customid => location.customid).first.id
		end
		return locationid
	end

	# returns true if this location has no more offerings
	def isEmpty?
		return self.offerings.count == 0
	end
end