class Offering < ActiveRecord::Base

	include PublicActivity::Common

	has_one :location
	belongs_to :user
	validates :sub_location, presence: true
	validates :description, presence: true

  # destroys an offering
  # also destroys the location if the location becomes empty as a result of the offering deletion
  # returns true if this offering's location was destroyed
	def custom_destroy
	  self.destroy  
      # destroy location if no more offerings in this location
      location = Location.find(self.location_id)
	  if location.isEmpty?
        puts "EMPTY LOCATION"
        location.destroy
        return true
      else
      	puts "NONEMPTY LOCATION"
        return false
      end
	end

	# deletes stale offerings from the database. 
	# This method is called by a cron job every 10 minutes (made short for testing purposes)
	def self.remove_stale
		self.all.each do |offer|
			if offer.is_stale?(300)
				#offer.destroy
				offer.custom_destroy
			end
		end
	end

	# returns true if this offering was created more than 5 min ago (short time so that staff can test if they desire)
	# run "heroku run rake remove_stale_offerings" to run this just once immediately
	def is_stale?(grace_period)
		seconds_elapsed = Time.now - self.created_at
		return seconds_elapsed > grace_period
	end

	def vote_to_destroy(session)
		self.increment!(:numDeleteVotes)
		session[:votes].push(self.id)
	end

	def sufficient_votes?
		return self.numDeleteVotes >= 3
	end
end
