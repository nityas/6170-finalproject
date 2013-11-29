class IncomingemailsController < ApplicationController
  require 'mail'
  require 'rest_client'
  require 'json'
  skip_before_filter :verify_authenticity_token

  # GET /locations/new
  def new
    @incomingemails = Incomingemail.new
  end

  def create
    #Get the subject line and parse for location
    subjectString = params[:headers]['Subject']
    @location = subjectString.match(/(\w?\d{1,2}\w?[-]?\d{0,3})/)
    @sublocation = subjectString
    @description = params[:plain]
    #if the location was parse create the location. 
    if !@location.nil?
      response = RestClient.get 'http://whereis.mit.edu/search', {:params => {:type => 'query', :q => @location, :output =>'json'}}
      response = JSON.parse(response)

      #creating a new location or getting the current location
      @newLocation = Location.new
      @newLocation.latitude = response[0]["lat_wgs84"]
      @newLocation.longitude = response[0]["long_wgs84"]
      @newLocation.title = response[0]["name"]
      @newLocation.customid = response[0]["id"]
      @newLocation.building_number = response[0]["bldgnum"]
      @newLocationId = Location.get_or_create_id(@newLocation)

      #create the offering, should probably do a redirect to preserve rails security
      @offering = Offering.new
      @offering.sub_location = @sublocation
      @offering.description = @description
      @offering.location_id = @newLocationId
      @offering.save
    end
    respond_to do |format|
      format.html{render :text => 'success', :status => 200}
      format.json{}
    end
  end
end