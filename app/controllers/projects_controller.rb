class ProjectsController < ApplicationController
	def index
	end

	def show
		@project = Project.find(params[:id])
	end

	def new
		@project = Project.new
	end

	def create
	end

	def edit
	end

	def update
	end

	def programming_project
		@project = Project.new
		respond_to do |format|
      format.js { render :layout => false }
    end
	end

	def blog_project
		@project = Project.new
		respond_to do |format|
      format.js { render :layout => false }
    end
	end

end
