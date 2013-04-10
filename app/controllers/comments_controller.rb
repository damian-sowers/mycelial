class CommentsController < ApplicationController

  before_filter :authenticate_user!, except: [:show, :index]
  before_filter :comment_update_privelidges?, only: [:update]
  before_filter :comment_destroy_privelidges?, only: [:destroy]
  #before_filter :get_sidebar_info, except: [:index, :show]

  def new
    @comment = Comment.new(:parent_id => params[:parent_id])
    @project_id = params[:project_id]
    respond_to do |format|
      format.html { render :partial => "new" }
    end
  end

  def create 
    @user_id = Project.find(params[:comment][:project_id]).page.user.id

    @comment = Comment.new(params[:comment])
    @comment.user_id = current_user.id
    @comment.username = current_user.username
    if @comment.save
      if @user_id != @comment.user_id
        send_comment_notification_email(@comment.id)
      end

      redirect_to :controller => "projects", :action => "show", :id => @comment.project_id, only_path: true
      expire_action(:controller => "/pages", :action => "show", :id => User.find(@user_id).username)
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
      redirect_to project_path(:id => @comment.project_id), only_path: true
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

    #delete the notification associated with the comment
    notification = @comment.notifications
    notification.destroy

    expire_action(:controller => "/pages", :action => "show", :id => Project.find(project_id).page.user.username)

    #test to see if the comment has any children. If so, just rewrite the body to "deleted".
    if @comment.has_children?
      @comment.comment = "Deleted"
      if @comment.save
        flash[:success] = "Your comment was updated"
        redirect_to project_path(:id => project_id), only_path: true
      else 
        flash[:error] = "Something went wrong"
        redirect_to project_path(:id => project_id), only_path: true
      end
    else
      @comment.destroy
      redirect_to project_path(:id => project_id), only_path: true
    end
  end

  private

    def get_comment_user
      @user = Comment.find(params[:id]).user
    end

    def comment_owner? 
      @comment_user = get_comment_user()
      if @comment_user
        current_user?(@comment_user)
      else 
        return false
      end
    end

    def comment_update_privelidges? 
      redirect_to(root_path) unless comment_owner?()
    end

    def get_project_id_from_comment_id
      project_id = Comment.find(params[:id]).project_id
    end

    def comment_destroy_privelidges? 
      #check to see if author first, then also check to see if user is owner of project. Both give ownership over destroy action.
      project_id = get_project_id_from_comment_id()
      return false unless is_page_owner?(project_id) or comment_owner?()
    end

    def send_comment_notification_email(comment_id)
      @comment = Comment.find(comment_id)
      #need to get the email of the owner of the project
      @user_email = Project.find(@comment.project_id).page.user.email
      #send email
      NotificationMailer.send_comment_notification(@comment, @user_email).deliver
      #Resque.enqueue(CommentMailer, comment_id)
    end
end
