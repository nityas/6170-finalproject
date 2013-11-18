class Offering < ActiveRecord::Base
	has_one :location
	validates :sub_location, presence: true
	validates :description, presence: true
end
