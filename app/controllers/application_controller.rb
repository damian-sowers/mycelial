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

    def get_sidebar_info
			if user_signed_in?
				@page = sidebar_data(current_user.id)
			end
		end
end
