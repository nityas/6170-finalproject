class LocationsController < ApplicationController
  before_action :signed_in_user, only: [:create, :update, :new]
  before_action :set_location, only: [:show, :edit, :update, :destroy]

  # GET /locations
  # GET /locations.json
  def index
    @locations = Location.all
    # for each location create a marker.
    # a marker has latitude,longitude, and infowindow with offerings
    # and a pin
    @hash = Gmaps4rails.build_markers(@locations) do |location, marker|
      marker.lat location.latitude
      marker.lng location.longitude
      offering = Offering.new
      custom_location_id = location.customid
      if signed_in?
        marker.infowindow render_to_string(:partial => "offerings/add", :locals => {:@offering => offering, :@location => location} )
      end
      marker.picture({
       "url" => "assets/pin.png",
       "width" =>  50,
       "height" => 68})
    end
  end

  #POST /locations/exists
  #@param of whereismit custom id
  def exists
    location_exists = !!Location.exists?(customid: params[:mitlocation_id])
    respond_to do |format|
      format.html
      format.json {render json: location_exists }
    end
  end

  # GET /locations/new
  def new
    @location = Location.new
  end

  # POST /locations
  # POST /locations.json
  # creates an MIT-location unless this location already exists 
  def create
    @location = Location.new(location_params)
    unless Location.exists?(:customid => location_params[:customid])    
      if @location.save
        flash[:notice] = "Saved Location"
      else
        flash[:alert] = "Problem saving this location"
      end
    end
    redirect_to root_path
  end

  # PATCH/PUT /locations/1
  # PATCH/PUT /locations/1.json
  def update
    respond_to do |format|
      if @location.update(location_params)
        format.html { redirect_to @location, notice: 'Location was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.json
  def destroy
    @location.destroy
    respond_to do |format|
      format.html { redirect_to locations_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.

    def signed_in_user
        redirect_to root_url, alert: "Action Unsuccessful, please sign in." unless signed_in?
    end

    def set_location
      @location = Location.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def location_params
      params.require(:location).permit(:latitude, :longitude, :customid,  :title, :building_number)
    end
end
