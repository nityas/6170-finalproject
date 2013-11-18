class IncomingemailsController < ApplicationController
  require 'mail'
  skip_before_filter :verify_authenticity_token

  def create
    #Get the subject line and parse for location
    subjectString = params[:headers]['Subject']
    location = subjectString.match(/(\w?\d{1,2}\w?[-]?\d{0,3})/)
    sublocation = location
    #if the regex didn't fing a building location, set location to empty string and call the js function
    if location.nil?
    	location = ""
    end
    respond_to do |format|
    	format.js {}
        format.html { render :text => 'success', :status => 200}
        format.json {}
    end
  end
end