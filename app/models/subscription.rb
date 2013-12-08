class Subscription < ActiveRecord::Base
	has_one :location

	#checks if the user is subscribed to a given location
	def subscribed(location,user_id)
		return !Subscription.exists?(location_id:location.id , user_id: user_id)
	end
end
