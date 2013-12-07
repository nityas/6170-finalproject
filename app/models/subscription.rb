class Subscription < ActiveRecord::Base
	has_one :location
	def subscribed(location,user_id)
		return !Subscription.exists?(location_id:location.id , user_id: user_id)
	end
end
