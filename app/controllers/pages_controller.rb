class PagesController < ApplicationController

	before_filter :authenticate_user!, except: [:show, :load_more, :about]
	before_filter :correct_user, only: [:edit, :update, :destroy]
	#get the sidebar data from the session user id for the logged in methods like edit, update
	before_filter :get_sidebar_info, only: [:index, :edit, :update]
	before_filter :set_projects_per_page
	before_filter :only_admin_allowed, only: [:index, :destroy]
	after_filter :expire_cache_if_no_projects, only: [:show]
	caches_action :show, :about, :layout => false, :cache_path => Proc.new { |c| c.params }
	

	def index
		@users_count = User.count
		@pages = Page.order("created_at DESC")
	end

	def new 
		@page = Page.new
		#need to check if the user already has a page. if they do then redirect to edit
		if @check = User.find(current_user.id).page
			redirect_to :action => "edit", :id => @check.id, only_path: true
		end
	end

	def show 
		@page_caching = true
		@user = User.find_by_username(params[:id])
		@page = @user.page
		total_projects = @page.projects.count
		@total_pages = (total_projects.to_f / @projects_per_page.to_f).ceil
		if params[:offset]
			@offset = Integer(params[:offset]) + 1
			limit_num = (Integer(params[:offset]) + 1) * @projects_per_page
		else
			limit_num = @projects_per_page
		end
		@offset ||= 1
		@projects = @page.projects.order("position ASC").limit(limit_num)
	end

	def about
		@page_caching = true
		@user = User.find_by_username(params[:id])
		@page = @user.page
	end

	def load_more

		offset_num = Integer(params[:offset])
		offset = @projects_per_page * offset_num

		@user = User.find_by_username(params[:author])
		@page = @user.page
		@projects = @page.projects.order("page_order ASC").limit(@projects_per_page).offset(offset)

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
		@projects = Page.find(params[:id]).projects.order("position ASC")
	end

	def create 
		@page = Page.new(params[:page])
		@page.user_id = current_user.id
		if @page.save
			session[:page_id] = @page.id 
			flash[:success] = "Your page has been created."
			redirect_to @page, only_path: true
		else 
			render 'new'
		end
	end

	def update
		@page.user_name_class = get_formatted_user_name_class(params[:page][:name])
		if @page.update_attributes(params[:page])
      #handle a successful update
      #get rid of this session variable in the update eventually. Need to figure out a way to get this upon login, and also assign it during create. 
      session[:page_id] = @page.id
 			if params[:page][:new_user]
				#send to step 2. Add your first project. append var to tell new projects controller it's a new user
				redirect_to :controller => "projects", :action => "new_project", :new_user => 1, only_path: true
			else 
      	flash[:success] = "Page updated"
      	redirect_to :action => "edit", :id => params[:id], only_path: true
      end
    else 
    	flash[:error] = "Something went wrong"
      render 'edit'
    end
    expire_action(:controller => "/pages", :action => "show", :id => @page.user.username)
    expire_action(:controller => "/pages", :action => "about", :id => @page.user.username)
	end

	def delete_picture
		r = Page.find(params[:id])
		r.remove_image!
		r.remove_image = true
		r.save
		respond_to do |format|
			format.html
      format.js { render :layout => false }
    end
	end

	def destroy
	end

	private

		def set_projects_per_page
			@projects_per_page = 20
		end
		
		def get_user 
			@user = Page.find(params[:id]).user
		end

		def get_formatted_user_name_class(name)
	    #steps to take: split the name based on the whitespace. Take the length of each segment. If length less than or equal to 7 characters, render the big name. 
	    length_class = ["name_size_1", "name_size_2", "name_size_3", "name_size_4", "name_size_5"]
	    length_flag = 0
	    name_format = ""
	    name_array = name.split(" ")
	    length_array = []
	    name_array.each do |f| 
	      length_array << f.length 
	    end

	    if length_array.max.between?(0,7)
	      name_format = length_class[0]
	    elsif length_array.max.between?(8,9)
	      name_format = length_class[1]
	    elsif length_array.max.between?(10,12)
	      name_format = length_class[2]
	    elsif length_array.max.between?(13,16)
	      name_format = length_class[3]
	    else 
	      name_format = length_class[4]
	    end
	    return name_format
	  end

	  def expire_cache_if_no_projects
	  	if !@projects or @projects == []
	  		if @page
					expire_action(:controller => "/pages", :action => "show", :id => @page.user.username)
				end
			end
	  end
end
