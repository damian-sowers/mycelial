class ApplicationController < ActionController::Base
  protect_from_forgery

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

    def is_page_owner?(project_id)
      #first find the user_id that corresponds to this project_id
      page_user_id = Project.find(project_id).page.user.id
      #will return true or false
      page_user_id == current_user.id
    end

    def get_sidebar_info
			if user_signed_in?
				@page = sidebar_data(current_user.id)
			end
		end
end
