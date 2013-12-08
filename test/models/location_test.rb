require 'test_helper'

class LocationTest < ActiveSupport::TestCase

  #test if we are not creating duplicated names as well as 
  #undefined names, if a building does not have a building number 
  test "get_title_description" do
  	@location = make_location_lite('Stata 32', '32')
  	assert @location.get_title_description() == "Building 32"

  	@location = make_location_lite('Stata', '32')
  	assert @location.get_title_description() == "Building 32- Stata"

  	@location = make_location_lite('pika', nil)
  	assert @location.get_title_description() == "pika"
 
  end

  # test if the location does not contain any offers.
  # return ture if empty, and false otherwise.
  test "isEmpty" do
  	@location = make_location
  	assert @location.isEmpty? == true

  	@offering = make_offering(@location.id)
  	assert @location.isEmpty? == false

  	@offering.destroy
  	assert @location.isEmpty? == true
  end


  # create a location with just the title and building number
  def make_location_lite(title, bldg_num)
  	@location = Location.new
  	@location.title = title
  	@location.building_number = bldg_num
  	return @location
  end

  #creeate a location
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

  #create an offering
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
