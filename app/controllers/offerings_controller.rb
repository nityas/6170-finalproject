class OfferingsController < ApplicationController
  before_action :signed_in_user, only: [:create, :update, :new]
  before_action :set_offering, only: [:edit, :update, :destroy]

  # GET /offerings/new
  def new
    @offering = Offering.new()
  end

  # POST /offerings
  # POST /offerings.json
  # @params location - custom id gotten from whereismit
  # @params sublocation - text descriptor of location
  # @params description - description of food offered
  def create
    @offering = Offering.new
    @offering.sub_location = params[:offering][:sub_location]
    @offering.description = params[:offering][:description]
    @offering.numDeleteVotes = 0
    @offering.location_id = Location.where(:customid => params[:offering][:location]).first.id

    respond_to do |format|
      if @offering.save
        OffersMailer.offer_mail("ido.p.efrati@gmail.com").deliver
        format.html { redirect_to root_url, notice: 'Byte was successfully created.' }
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
        format.html { redirect_to root_url, notice: 'Byte was successfully updated.' }
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
    location_id = @offering.location_id
    @location = Location.find(location_id)
    @vote_history = session[:votes]

    #cast a vote to destroy offering
    @offering.vote_to_destroy(session)

    # destroy offering if enough votes cast
    if @offering.sufficient_votes?
      @offering.destroy
      # destroy location if no more offerings in this location
      if @location.isEmpty?
        message = 'Byte was successfully removed. No more Bytes at %{name}.' % {:name => @location.title}
        @location.destroy

        #TODO: figure out how to make this reload even though we did :remote => true client-side
        redirect_to root_path, notice: message
      else
        respond_to do |format|
          format.js {}
          format.json {render :json => @vote_history}
        end
      end

    else
      respond_to do |format|
        format.js {}
        format.json {render :json => @vote_history}
      end
    end
  end


  private

    def signed_in_user
        redirect_to root_url, alert: "Action Unsuccessful, please sign in." unless signed_in?
    end
    # Use callbacks to share common setup or constraints between actions.

    def set_offering
      @offering = Offering.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def offering_params
      params.permit(:offering, :location, :sub_location, :description)
    end
end
