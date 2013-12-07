class Location < ActiveRecord::Base
	has_many :offerings, dependent: :destroy
	has_many :subscriptions


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

	def get_title_description()
		if !self.building_number.nil?
			if self.title.include? self.building_number
				return "Building " + self.building_number
			else
				return "Building " + self.building_number + "- " + self.title
			end
		else
			return self.title
		end
	end

	# returns true if this location has no more offerings
	def isEmpty?
		return self.offerings.count == 0
	end
end