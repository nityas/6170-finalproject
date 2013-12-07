class SubscriptionsController < ApplicationController
  before_action :set_subscription, only: [:destroy]


  # GET /subscriptions/new
  def new
    @subscription = Subscription.new
  end

  # POST /subscriptions
  # POST /subscriptions.json
  def create
    @subscription = Subscription.new(subscription_params)
    respond_to do |format|
      if @subscription.save
        format.html { redirect_to root_url, notice: 'Subscription was successfully created.' }
        format.json { render action: 'show', status: :created, location: @subscription }
      else
        format.html { render action: 'new' }
        format.json { render json: @subscription.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subscriptions/1
  # DELETE /subscriptions/1.json
  def destroy
    @subscription.destroy
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end


  #GET /locations/exists
  #@param mitlocation_id from whereismit custom id
  #check if a location already exist in the database or not
  def exists
    subscription_exists = Subscription.subscribed(params[:location_id], params[:usr_id])
    
    respond_to do |format|
      format.html
      format.json {render json: subscription_exists }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subscription
      @subscription = Subscription.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def subscription_params
      params.require(:subscription).permit(:location_id, :user_id)
    end
end
