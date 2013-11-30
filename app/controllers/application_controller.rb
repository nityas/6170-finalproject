class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :check_voting_cookie
  include SessionsHelper	

    # if client does not have cookie, creates order and sets cookie to be the order id
  def check_voting_cookie
    unless session[:votes]
      session[:votes] = []
    end
    puts "VOTING INFO"
    session[:votes].each do |vote|
    	puts vote
    end
  end  
end
