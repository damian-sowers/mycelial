class CommentsController < ApplicationController
	def show
	end

	def new
		@comment = Comment.new
		@project_id = params[:project_id]
		respond_to do |format|
			format.html { render :partial => "new" }
    end
	end

	def create 
		@comment = Comment.new(params[:comment])
		@comment.user_id = current_user.id
		if @comment.save
			redirect_to :controller => "projects", :action => "show", :id => @comment.project_id, only_path: true
		else
			flash[:error] = "Something went wrong."
			redirect_to :controller => "projects", :action => "show", :id => @comment.project_id, only_path: true
		end
	end

	def edit
	end

	def update
	end

	def destroy
	end
end
