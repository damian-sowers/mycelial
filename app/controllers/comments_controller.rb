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
    	@user = Comment.find(params[:id]).project.page.user
    end

    #only call this for the signed in methods. When they are editing their projects. sidebar_data is in a module.
		def get_sidebar_info
			if user_signed_in?
				@page = sidebar_data(current_user.id)
			end
		end
end
