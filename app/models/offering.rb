class Offering < ActiveRecord::Base
	has_one :location
	validates :sub_location, presence: true
	validates :description, presence: true

	def clear_empty_location(location_id)
		return  Location.find(location_id).offerings.size == 1
	end
end
