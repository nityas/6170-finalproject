require 'test_helper'

class LocationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end


   def make_location
  	@location = Location.new
  	@location.latitude = 1.1
  	@location.longitude = 1.1
  	@location.title = "Stata"
  	@location.customid = "test"
  	@location.building_number = "test"
  	@location.save
  	return @location
  end


  def make_offering(loc_id)
    @offering = Offering.new
    @offering.owner_id = 1
    @offering.location_id = loc_id
    @offering.numDeleteVotes = 0
    @offering.sub_location = "test"
    @offering.description = "test"
    @offering.last_seen = Time.now
    @offering.save
    return @offering
  end
end
