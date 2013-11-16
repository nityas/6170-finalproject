class IncomingemailsController < ApplicationController
  require 'mail'
  skip_before_filter :verify_authenticity_token
  def create
    # Do some other stuff with the mail message
    subjectString = params[:headers]['Subject']
    location = subjectString.match(/(\w?\d{1,2}\w?[-]?\d{0,3})/)
    if location.nil?
        location = ""
    end
    render :text => 'success', :status => 200 # a status of 404 would reject the mail
  end
end