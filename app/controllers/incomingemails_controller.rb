class IncomingemailsController < ApplicationController
  require 'mail'
  require 'rest_client'
  require 'json'
  skip_before_filter :verify_authenticity_token

  def create
    #Get the subject line and parse for location
    @information = Incomingemail.parseEmail(params[:headers]['Subject'], params[:plain])

    @location = @information[0]
    @sublocation = @information[1]
    @description = @information[2]
    @to = params[:envelope][:to]


    #if the location was parse create the location. 
    successful_email = false
    if !@location.nil? && Incomingemail.correctToEmail(@to)
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