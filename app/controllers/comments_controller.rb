class CommentsController < ApplicationController
	include Mycelial

	before_filter :authenticate_user!, except: [:show, :index]
	before_filter :correct_user, only: [:edit, :update, :destroy]
	before_filter :get_sidebar_info, except: [:index, :show]

	def show
	end

	def new
		@comment = Comment.new(:parent_id => params[:parent_id])
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
		@comment = Comment.find(params[:id])
		@page_owner = page_owner()
		render :partial => "edit"
	end

	def update
		@comment = Comment.find(params[:id])
		if @comment.update_attributes(params[:comment])
      flash[:success] = "Your comment was updated"
      redirect_to "/projects/#{@comment.project_id}", only_path: true
    else 
      render 'edit'
    end
	end

	def pencil
		render :partial => "pencil"
	end

	def destroy
		@comment = Comment.find(params[:id])
		project_id = @comment.project_id

		#test to see if the comment has any children. If so, just rewrite the body to "deleted".
		if @comment.has_children?
			@comment.comment = "Deleted"
			if @comment.save
      	flash[:success] = "Your comment was updated"
      	redirect_to "/projects/#{@comment.project_id}", only_path: true
    	else 
    		flash[:error] = "Something went wrong"
      	redirect_to "/projects/#{@comment.project_id}", only_path: true
      end
		else
    	@comment.destroy
    	redirect_to "/projects/#{project_id}", only_path: true
    end
	end

	private

    def get_user
    	@user = Comment.find(params[:id]).project.page.user
    end
end
