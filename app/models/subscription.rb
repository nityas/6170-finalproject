class Subscription < ActiveRecord::Base
	has_one :location

	#checks if the user is subscribed to a given location
	def self.subscribed(mitlocation,user_id)
		return !Subscription.exists?(mitlocation_id: mitlocation, user_id: user_id)
	end

	def self.getSubscribedId(mitlocation, user_id)
		if !Subscription.where(mitlocation_id: mitlocation, user_id:user_id).first.nil?
			return Subscription.where(mitlocation_id: mitlocation, user_id:user_id).first.id
		else
			return -1
		end
	end
end
