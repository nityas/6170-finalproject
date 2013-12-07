class IncomingemailsController < ApplicationController
  require 'mail'
  require 'rest_client'
  require 'json'
  skip_before_filter :verify_authenticity_token

  def create
    #Get the subject line and parse for location
    subjectString = params[:headers]['Subject']
    @location = subjectString.match(/(\w?\d{1,2}\w?[-]?\d{0,3})/)
    @sublocation = subjectString
    @description = params[:plain]
    #if the location was parse create the location. 
    successful_email = false
    if !@location.nil?
      response = RestClient.get 'http://whereis.mit.edu/search', {:params => {:type => 'query', :q => @location, :output =>'json'}}
      response = JSON.parse(response)[0]

      if !response.nil?
        #creating a new location or getting the current location
        @newLocation = Location.new
        @newLocation.latitude = response["lat_wgs84"]
        @newLocation.longitude = response["long_wgs84"]
        @newLocation.title = response["name"]
        @newLocation.customid = response["id"]
        @newLocation.building_number = response["bldgnum"]
        @newLocationId = Location.get_or_create_id(@newLocation)
        successful_email = true;
        #create the offering, should probably do a redirect to preserve rails security
        @offering = Offering.new
        @offering.sub_location = @sublocation
        @offering.description = @description
        @offering.location_id = @newLocationId
        if @offering.save
          OffersMailer.offer_mail(@offering)
        end
      end
    end
    respond_to do |format|
      format.html{render :text => 'success', :status => 200}
      format.json{}
    end
  end
end