class CommentsController < ApplicationController
	include Mycelial

	before_filter :authenticate_user!, except: [:show, :index]
	before_filter :correct_user, only: [:update]
	before_filter :owner_of_page?, only: [:destroy]
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
		#need to get the user.id for pusher
		@user_id = Project.find(params[:comment][:project_id]).page.user.id

		@comment = Comment.new(params[:comment])
		@comment.user_id = current_user.id
		@comment.username = current_user.username
		if @comment.save
			# Send a Pusher notification
			if @comment.is_root? 
				data = {'message' => 'New Notification'}
      	Pusher['private-' + @user_id.to_s].trigger('new_comment', data)
      else 
      	#get the parent id of this comment. Fetch the comment record and the comment user_id. Also send a notification to this person. 
      	parent_id = @comment.parent_id
      	parent_user_id = Comment.find(parent_id).user_id
      	data = {'message' => 'New Notification'}
      	Pusher['private-' + parent_user_id.to_s].trigger('new_comment', data)
      	Pusher['private-' + @user_id.to_s].trigger('new_comment', data)
      end

			redirect_to :controller => "projects", :action => "show", :id => @comment.project_id, only_path: true
		else
			flash[:error] = "Something went wrong."
			redirect_to :controller => "projects", :action => "show", :id => @comment.project_id, only_path: true
		end
	end

	def edit
		@comment = Comment.find(params[:id])
		@page_owner = is_page_owner?(params[:project_id])
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

	def loadmore
		@project = Project.find(params[:project_id])
		@page_owner = page_owner()
		@comments = Project.find(params[:project_id]).comments.arrange(:order => :created_at)
		respond_to do |format|
			format.html 
      format.js { render :layout => false }
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
		#this method is a problem for the edit function if user who is editing comment not the owner of the page. Need to change. 
    def get_user
    	@user = Comment.find(params[:id]).user
    end

    def owner_of_page? 
    	project_id = Comment.find(params[:id]).project_id
    	owner_user_id = Project.find(project_id).page.user.id
    	current_user.id == owner_user_id
    end
end
