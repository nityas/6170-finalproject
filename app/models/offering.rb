class Offering < ActiveRecord::Base
	has_one :location
	belongs_to :user
	validates :sub_location, presence: true
	validates :description, presence: true
end
