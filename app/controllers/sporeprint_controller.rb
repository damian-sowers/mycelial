class SporeprintController < ApplicationController

	def show
		@original_project = Project.find(params[:id])
		@projects = @original_project.find_related_tags.limit(2)
		@total_pages = 1
		render 'pages/show'
	end
end
