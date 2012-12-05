class PagesController < ApplicationController

	before_filter :authenticate_user!, except: [:show, :index]
	before_filter :correct_user, only: [:edit, :update, :destroy]
	#get the sidebar data from the session user id for the logged in methods like edit, update
	before_filter :get_sidebar_info, only: [:edit, :update]
	before_filter :set_projects_per_page

	def index
		@page = Page.all
	end

	def new 
		@page = Page.new
		#need to check if the user already has a page. if they do then redirect to edit
		if @check = User.find(current_user.id).page
			redirect_to :action => "edit", :id => @check.id, only_path: true
		end
	end

	def show 
		@user = User.find_by_username(params[:id])
		@page = @user.page
		@projects = @page.projects.limit(@projects_per_page)
		#need to paginate this somehow. Maybe just limit 10, and a new method that gets called via ajax that finds the projects offset by 10*page? 
	end

	def load_more

		offset_num = Integer(params[:offset])
		offset = @projects_per_page * offset_num

		@user = User.find_by_username(params[:author])
		@page = @user.page
		@projects = @page.projects.limit(@projects_per_page).offset(offset)

		respond_to do |format|
			format.html { render :partial => 'more_projects' }
      format.js { render :layout => false }
    end
	end

	def demo
		#some hardcoded examples
		@user = User.find_by_username('dsowers')
		@page = @user.page
	end

	def edit
		@projects = Page.find(params[:id]).projects
	end

	def create 
		@page = Page.new(params[:page])
		@page.user_id = current_user.id
		if @page.save
			session[:page_id] = @page.id
			if params[:page][:image].present?
				render 'crop'
			else 
				flash[:success] = "Your page has been created."
				redirect_to @page, only_path: true
			end
		else 
			render 'new'
		end
	end

	def update
		if @page.update_attributes(params[:page])
      #handle a successful update
      #get rid of this session variable in the update eventually. Need to figure out a way to get this upon login, and also assign it during create. 
      session[:page_id] = @page.id
      if params[:page][:image].present?
				render 'crop'
			else 
      	flash[:success] = "Page updated"
      	redirect_to :action => "edit", :id => params[:id], only_path: true
      end
    else 
      render 'edit'
    end
	end

	def destroy
	end

	private

		def set_projects_per_page
			@projects_per_page = 3
		end
		def get_user 
			@user = Page.find(params[:id]).user
		end
end
