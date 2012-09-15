class ProjectsController < ApplicationController
	def index
	end

	def show
		@project = Project.find(params[:id])
	end

	def new
	end

	def create
	end

	def edit
	end

	def update
	end

	def ajax_project_type
		@project_number = params[:project_number]
		if @project_number == 1
			render 'programming_project'
		end
	end
end
