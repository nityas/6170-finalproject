class UsersController < ApplicationController
  require 'rest_client'
  require 'json'
  before_action :set_user, only: [:edit, :update, :destroy]
  before_action :signed_in_user, only: [:edit, :update]

  # GET /users/new
  def new
    @user = User.new
  end

  def exists
    signedin = signed_in?
    respond_to do |format|
      format.html
      format.json {render json: signedin }
    end
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    
    #query mit people search to confirm valid mit email
    @kerberos = @user.email.split('@')[0]
    @info = RestClient.get 'http://web.mit.edu/bin/cgicso?', {:params => {:options => "general", :query => @kerberos, :output =>'json'}}
    responseEmail = @kerberos + "@MIT.EDU"
    @user.provider = @user.provider_to_email(user_params[:provider])
    puts "$$$$$"
    puts @user    
    respond_to do |format|
      if @info.include?(responseEmail)
        if @user.save
          puts "$$$$$4"
          puts @user
          puts @user.provider
          puts "%%%%%%"
          sign_in @user
          format.html { redirect_to root_url, notice: 'User was successfully created.' }
          format.json { render action: 'show', status: :created, location: @user }
        else
          format.html { render action: 'new', notice: 'Not a valid MIT email.'}
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end    
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to root_url, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      sign_out
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.

    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email,:phoneNumber, :provider, :password,:password_confirmation)
    end

    def signed_in_user
      redirect_to signin_url, notice: "Please sign in." unless signed_in?
    end
end
