class LocationsController < ApplicationController
  before_action :set_location, only: [:show, :edit, :update, :destroy]

  # GET /locations
  # GET /locations.json
  def index
    @locations = Location.all
    @hash = Gmaps4rails.build_markers(@locations) do |location, marker|
      marker.lat location.latitude
      marker.lng location.longitude

      marker.infowindow render_to_string(:partial => "offerings/add", :locals => {:@offering => Offering.new} )

      marker.picture({
       "url" => "assets/pin.png",
       "width" =>  50,
       "height" => 68})

    end

  end

  # GET /locations/1
  # GET /locations/1.json
  # def show
  #   @temp_location = params
  #   @json = @temp_location.to_gmaps4rails do |location, marker|
  #     marker.infowindow render_to_string(:partial => "/layouts/partials/_carrietest.html.erb")
  #   end

  #   respond_to do |format|
  #     index.html
  #   end
  # end

  # GET /locations/new
  def new
    @location = Location.new
  end

  # GET /locations/1/edit
  def edit
  end

  # POST /locations
  # POST /locations.json
  # creates an MIT-location unless this location already exists 
  def create

    @location = Location.new(location_params)

    respond_to do |format|
      if Location.exists?(:customid => location_params[:customid])
        format.html { render action: 'new' }
      else
        if @location.save
          format.html { redirect_to @location, notice: 'Location was successfully created.' }
          format.json { render action: 'show', status: :created, location: @location }
        else
          format.html { render action: 'new' }
          format.json { render json: @location.errors, status: :unprocessable_entity }
        end

      end
    end

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
    def set_location
      @location = Location.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def location_params
      params.require(:location).permit(:latitude, :longitude, :customid, :address, :title, :description)
    end
end
