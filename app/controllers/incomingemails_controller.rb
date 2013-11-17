class IncomingemailsController < ApplicationController
  require 'mail'
  skip_before_filter :verify_authenticity_token

  def create
    # Do some other stuff with the mail message
    subjectString = params[:headers]['Subject']
    location = subjectString.match(/(\w?\d{1,2}\w?[-]?\d{0,3})/)
    #if the regex found a building location, call the js querry


    respond_to do |format|
		format.html {}
		#if !location.nil?
		#	create_search(location)
		#end
		#format.js {  render :js =>  "create_search(location);" }
		format.js window.alert("Test")
	end
  end
end