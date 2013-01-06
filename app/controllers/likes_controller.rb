class LikesController < ApplicationController
	before_filter :authenticate_user!, except: [:show]

	def create
    @like = Like.create(params[:like])
    @project_id = params[:like][:project_id]
    #send a delayed job push notification to the user. Get the owner user_id from project_id
    @user_id = Project.find(@project_id).page.user.id
    if @user_id != current_user.id
      send_like_notification_email(@like.id)
    end
    expire_action(:controller => "/pages", :action => "show", :id => Project.find(@project_id).page.user.username)
    render :toggle
  end

  def ajax_like
    #for people who like by clicking on the heart icon, before they are inside the project
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
          send_like_notification_email(r.id)
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
    expire_action(:controller => "/pages", :action => "show", :id => Project.find(@project_id).page.user.username)
    render :toggle
  end

  def show
    @project = Project.find(params[:id])
    @page = @project.page
    @user = @page.user
    @project_id = params[:id]

    likes_per_page = 15

    if params[:page]
      @offset = (params[:page].to_i - 1) * likes_per_page
    end
    @offset ||= 0
    
    @people = Like.find(:all, :conditions => ["project_id = ?", params[:id]], :order => "created_at DESC", :offset => @offset, :limit => likes_per_page)

    @total_pages = (get_total_likes(params[:id]).to_f / likes_per_page.to_f).ceil
  end

  private

    def get_total_likes(project_id)
      @total_likes = Like.count(:all, :conditions => ["project_id = ?", project_id])
    end

    def send_like_notification_email(like_id)
      Resque.enqueue(LikeMailer, like_id)
    end
end
