class OfferingsController < ApplicationController
  before_action :set_offering, only: [:show, :edit, :update, :destroy]
  before_action :signed_in_user, only: [:show, :destroy]


  # GET /offerings
  # GET /offerings.json
  def index
    @offerings = Offering.all
  end

  # GET /offerings/new
  def new
    @offering = Offering.new()
  end

  # POST /offerings
  # POST /offerings.json
  def create
    @offering = Offering.new
    @offering.sub_location = params[:offering][:sub_location]
    @offering.description = params[:offering][:description]
    location = Location.find(params[:offering][:location])
    @offering.location_id = Location.get_or_create_id(location)
    respond_to do |format|
      if @offering.save
        format.html { redirect_to root_url, notice: 'Offering was successfully created.' }
        format.json { render action: 'show', status: :created, location: @offering }
      else
        format.html { render action: 'new' }
        format.json { render json: @offering.errors, status: :unprocessable_entity }
      end
    end

  end

  # PATCH/PUT /offerings/1
  # PATCH/PUT /offerings/1.json
  def update
    respond_to do |format|
      if @offering.update(offering_params)
        format.html { redirect_to root_url, notice: 'Offering was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @offering.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /offerings/1
  # DELETE /offerings/1.json
  def destroy
    @offering.destroy
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_offering
      @offering = Offering.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def offering_params
      params.permit(:offering, :location, :sub_location, :description)
    end
end
