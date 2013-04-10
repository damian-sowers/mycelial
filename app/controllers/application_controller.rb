class ApplicationController < ActionController::Base
  protect_from_forgery

  private

    def after_sign_in_path_for(resource)
      if resource.is_a?(User)
       page_path(:id => current_user.username)
      else
       super
      end
    end

    def after_sign_up_path_for(resource)
      if resource.is_a?(User)
       edit_page_path(:id => current_user.id, :new_user => 1)
      else
       super
      end
    end

    def current_user?(user)
      if user_signed_in?
        user.id == current_user.id
      else 
        return false
      end
    end

    def correct_user
      @user = get_user()
      if @user
        redirect_to(root_path) unless current_user?(@user) or current_user.email == "damian.sowers@gmail.com"
      else 
        redirect_to(root_path)
      end
    end

    def is_page_owner?(project_id)
      #first find the user_id that corresponds to this project_id
      page_user_id = Project.find(project_id).page.user.id
      #will return true or false
      if user_signed_in?
        page_user_id == current_user.id
      else 
        return false
      end
    end

    def get_sidebar_info
      if user_signed_in?
        @page = Page.find_by_user_id(current_user.id)
        @user = current_user
      end
    end

    def only_admin_allowed
      #do it by user email
      redirect_to root_path unless current_user.email == "damian.sowers@gmail.com" or current_user.email == "damian_sowers@yahoo.com"
    end
end
