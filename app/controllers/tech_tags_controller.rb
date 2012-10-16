class TechTagsController < ApplicationController

	include Mycelial

	before_filter :get_sidebar_info

	def index
  	@tags = TechTag.order(:name)
  	#render :text => @tech_tags.name
  	respond_to do |format|
    	format.html
    	format.json { render json: @tags.tokens(params[:q]) }
  	end
	end

	def show 
		@tech_tag = TechTag.find(params[:id])
	end

	def new
		@tech_tags = TechTag.new
	end

	def create
		@tech_tags = TechTag.new(params[:tech_tags])
		if @tech_tags.save
			redirect to @project
		end
	end

	private 

		def get_sidebar_info
			if user_signed_in?
				@page = sidebar_data(current_user.id)
			end
		end
end
