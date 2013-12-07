require 'test_helper'

class LocationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end	

  # test "get_title_description" do
  # 	@location = make_location()
  # 	assert @location.get_title_description == "Building 32- Stata 32"
  # end


   def make_location_withbldg
  	@location = Location.new
  	@location.title = "Stata 32"
  	@location.building_number = "32"
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
