class IncomingemailsController < ApplicationController
  require 'mail'
  skip_before_filter :verify_authenticity_token

  def create
    # Do some other stuff with the mail message
    subjectString = params[:headers]['Subject']
    location = subjectString.match(/(\w?\d{1,2}\w?[-]?\d{0,3})/)
    #if the regex found a building location, call the js querry

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