class ProjectsController < ApplicationController

	#module below. Inside the /lib folder. Autoloaded in config/application.rb (the whole lib folder. Might want to restrict to just load in the controllers I need)
	include Mycelial

	before_filter :authenticate_user!, except: [:show, :index]
	before_filter :correct_user, only: [:edit, :update]
	before_filter :get_sidebar_info, except: [:index, :show]

	def index
	end

	def show
		@project = Project.find(params[:id])
		page_id = @project.page_id
		#need to get the username, the users other projects to list on the right
		@user_name = Project.find(params[:id]).page.user.username
		#get project owners page data for the sidebar and the right sidebar
		@page = Page.find(page_id)
		@user_projects = Project.find_all_by_page_id(page_id)
		#get the tech tags for this project
		@tag_ids = Tagowner.find_all_by_project_id(params[:id])

		@tech_tags = Array.new
		@tag_ids.each do |f|
			#query for the rows associated with with these ids
			@tech_tags << TechTag.find(f.tech_tag_id)
		end
		@page_owner = page_owner()
	end

	def new_project 
	end

	def new
		@project = Project.new
	end

	def create
		@project = Project.new(params[:project])
		@project.page_id = Page.find_by_user_id(current_user.id).id
		if @project.save
			if params[:project][:picture].present?
				render 'crop'
			else 
				flash[:success] = "Your project has been created."
				redirect_to :action => "edit", :id => @project.id, only_path: true
			end
		end
	end

	def edit
		@project = Project.find(params[:id])
		#going to have to differentiate all the editable fields below. Maybe get the value of the param. 
		#like edit_block = 'short_description'. try render :partial => '#{params[:edit_block]}'
		if params[:edit_block]
			if params[:edit_block] == "tech_tags"
				render "_tech_tags"
			else 
				render :partial => "#{params[:edit_block]}"
			end
			# .to_i == 1
			# render :partial => 'project_type'
		end
	end

	def update
		@project = Project.find(params[:id])
		if @project.update_attributes(params[:project])
      #handle a successful update
   		#if params[:project][:picture].present?
			# 	render 'crop'
			# else 
      	flash[:success] = "Project updated"
      	redirect_to :action => "edit", :id => params[:id], only_path: true
      # end
    else 
      render 'edit'
    end
	end

	def project_type
		@project_type = params[:id]
		respond_to do |format|
			format.html 
      format.js { render :layout => false }
    end
	end

	def project_layout
		@project = Project.new
		@project_type = params[:project_type]
		@widget_type = params[:widget_type]
		respond_to do |format|
			format.html
      format.js { render :layout => false }
    end
	end

	private

		def current_user?(user)
			if user_signed_in?
				user.id == current_user.id
			end
		end

    def correct_user
    	@user = get_user()
    	if @user
      	redirect_to(root_path) unless current_user?(@user)
      else 
      	redirect_to(root_path)
      end
    end

    def page_owner
    	@user = get_user()
    	if @user 
    		if current_user?(@user)
      		@page_owner = 1
      	else 
      		@page_owner = 0
      	end
      else 
      	@page_owner = 0
      end
    end

    def get_user
    	@user = Project.find(params[:id]).page.user
    end

    #only call this for the signed in methods. When they are editing their projects. sidebar_data is in a module.
		def get_sidebar_info
			if user_signed_in?
				@page = sidebar_data(current_user.id)
			end
		end
end
