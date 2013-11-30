class Offering < ActiveRecord::Base
	has_one :location
	belongs_to :user
	validates :sub_location, presence: true
	validates :description, presence: true


	# deletes stale offerings from the database. 
	# This method is called by a cron job every minute
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

	# returns true if this offering was created more than 15 minutes (900 seconds) ago
	def is_stale?
		seconds_elapsed = Time.now - self.created_at
		return seconds_elapsed > 900
	end

	def vote_to_destroy(session)
		self.increment!(:numDeleteVotes)
		session[:votes].push(self.id)
	end

	def sufficient_votes?
		return self.numDeleteVotes >= 3
	end
end
