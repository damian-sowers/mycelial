class ProjectsController < ApplicationController
	before_filter :authenticate_user!, except: [:show, :index]
	before_filter :correct_user, only: [:edit, :update, :create]

	def index
	end

	def show
		@project = Project.find(params[:id])
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
				redirect_to :action => "edit", :id => @project.id
			end
		end
	end

	def edit
		@project = Project.find(params[:id])
	end

	def update
		@project = Project.find(params[:id])
		if @project.update_attributes(params[:project])
      #handle a successful update
      if params[:project][:picture].present?
				render 'crop'
			else 
      	flash[:success] = "Project updated"
      	redirect_to :action => "edit", :id => params[:id]
      end
    else 
      render 'edit'
    end
	end

	def project_type
		@project_type = params[:id]
		respond_to do |format|
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
			user.id == current_user.id
		end

    def correct_user
    	@user = Project.find(params[:id]).page.user
    	if @user
      	redirect_to(root_path) unless current_user?(@user)
      else 
      	redirect_to(root_path)
      end
    end

end
