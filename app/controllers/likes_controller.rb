class LikesController < ApplicationController
	before_filter :authenticate_user!, except: [:show]

	def create
    @like = Like.create(params[:like])
    @project_id = params[:like][:project_id]
    #send a delayed job push notification to the user. Get the owner user_id from project_id
    @user_id = Project.find(@project_id).page.user.id
    if @user_id != current_user.id
      Resque.enqueue(LikeNotifier, @user_id)
    end
    render :toggle
  end

  def ajax_like
    user_who_liked_project = User.find(params[:user_id])
    #make sure they haven't already liked this post. Also include this code client side. 
    unless already_liked_project = user_who_liked_project.likes.find_by_project_id(params[:project_id])
      r = Like.new
      r.user_id = params[:user_id]
      r.project_id = params[:project_id]
      r.username = User.find(params[:user_id]).username

      if r.save
        @receiving_user_id = Project.find(params[:project_id]).page.user.id
        if @receiving_user_id != params[:user_id].to_i
          Resque.enqueue(LikeNotifier, @receiving_user_id)
        end
      end
    end
    render :nothing => true
  end

  def destroy
    like = Like.find(params[:id]).destroy
    @project_id = like.project_id
    #delete the like notification with background job.
    Resque.enqueue(LikeNotificationDestroyer, params[:id])
    render :toggle
  end

  def show
    @project = Project.find(params[:id])
    @page = @project.page
    @user = @page.user

    @project_id = params[:id]

    #get all people who like this project id
    @people = Like.find(:all, :conditions => ["project_id = ?", params[:id]], :order => "created_at DESC")
    @likes_count = @people.count

    @people.each do |f|
      @people_like_array
    end
  end
end
