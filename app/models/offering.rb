class Offering < ActiveRecord::Base

	include PublicActivity::Common

	has_one :location
	belongs_to :user
	validates :sub_location, presence: true
	validates :description, presence: true


	# deletes stale offerings from the database. 
	# This method is called by a cron job every 10 minutes (made short for testing purposes)
	def self.remove_stale
		puts "remove_stale"
		self.all.each do |offer|
			if offer.is_stale?
				offer.destroy
				puts "DESTROYING offering #: "
				puts offer.id
			end
		end
	end

	# returns true if this offering was created more than 60 seconds ago (short time so that staff can test if they desire)
	# run "heroku run rake remove_stale_offerings" to run this just once immediately
	def is_stale?
		seconds_elapsed = Time.now - self.created_at
		return seconds_elapsed > 60
	end

	def vote_to_destroy(session)
		self.increment!(:numDeleteVotes)
		session[:votes].push(self.id)
	end

	def sufficient_votes?
		return self.numDeleteVotes >= 2
	end
end
