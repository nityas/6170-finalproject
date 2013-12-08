class Subscription < ActiveRecord::Base
	has_one :location

	#checks if the user is subscribed to a given location
	def subscribed(location,user_id)
		return !Subscription.exists?(location_id:location.id , user_id: user_id)
	end

	#first gets the id from the location and call subscribed. This is for incoming emails only
	def subscribedMitId(mitlocation,user_id)
		location = Location.find_by_customid(mitlocation)
		return subscribed(location,user_id)
	end
end
