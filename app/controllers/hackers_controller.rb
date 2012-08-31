class HackersController < ApplicationController
	before_filter :authenticate_user!, except: [:show, :index]
	before_filter :correct_user, only: [:edit, :update]

	def index
		@hacker = Hacker.all
	end

	def new 
		@hacker = Hacker.new
	end

	def show
		#need to get the username from users table and fetch appropriate hacker page based on this. 
		if is_numeric?(params[:id])
			@hacker = Hacker.find(params[:id])
		else 
			@hacker = User.find_by_username(params[:id]).hacker
		end
	end

	def edit
		@hacker = Hacker.find(params[:id])
	end

	def create 
		@hacker = Hacker.new(params[:hacker])
		@hacker.user_id = current_user.id
		if @hacker.save
			flash[:success] = "Your page has been created."
			redirect_to @hacker
		else 
			render 'new'
		end
	end

	def update
		@hacker = Hacker.find(params[:id])
		if @hacker.update_attributes(params[:hacker])
      #handle a successful update
      flash[:success] = "Page updated"
      redirect_to :action => "edit", :id => params[:id]
    else 
      render 'edit'
    end
	end

	private

		def current_user?(user)
			user.id == current_user.id
		end

    def correct_user
    	@user = Hacker.find(params[:id]).user
    	if @user
      	redirect_to(root_path) unless current_user?(@user)
      else 
      	redirect_to(root_path)
      end
    end

    def is_numeric?(obj) 
   		obj.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
		end
end
