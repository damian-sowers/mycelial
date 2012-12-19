module ApplicationHelper
	def controller?(*controller)
    controller.include?(params[:controller])
  end

  def action?(*action)
    action.include?(params[:action])
  end

  def render_sidebar()

  	path = 'layouts/sidebars/sidebar1'
    
  	if user_signed_in?
  		if controller?('feed') or controller?('sporeprint') 
  			#display 5.
  			render :partial => path, :locals => { :sidebar_number => 5 }
  		else
  			#display 2. 
  			render :partial => path, :locals => { :sidebar_number => 2 }
  		end
  	else
  		if controller?('feed') or controller?('sporeprint') 
  			#display 4.
  			render :partial => path, :locals => { :sidebar_number => 4 }
  		else
  			#display 3.
  			render :partial => path, :locals => { :sidebar_number => 3 }
  		end
  	end

  end	

  def on_own_page?(id)
  	#first need to determine if the controller is on pages or projects. If true, then get either the username or the project_id. Then find the user.id from this info and compare to current_user.id.
  	if controller?('pages') && action?('show')
			if is_numeric?(params[:id])
  			page_user_id = Page.find(params[:id]).user.id
  		else 
  			page_user_id = User.find_by_username(params[:id]).id
  		end
  		return users_match?(page_user_id)
  	elsif controller?('projects') 
  		project_user_id = Project.find(id).page.user.id
  		return users_match?(project_user_id)
    end
  end

  def users_match?(user_id)
  	current_user.id == user_id
  end

  def is_numeric?(obj) 
   	obj.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
	end

  def has_a_page?(user_id)
    begin
      p = User.find(user_id).page
    rescue
      return false
    end
    return true if p
  end

  def has_new_notifications?(user_id)
    begin
      n = Notification.where("receiver_id = ? AND viewed = ?", user_id, 0)
    rescue
      return false
    end
    return true unless n.empty?
  end

  #need to put this as a helper as well as application controller method, because devise registrations edit needs to get the sidebar info. Doesn't have its own controller
  def get_sidebar_info
    if user_signed_in?
      @page = Page.find_by_user_id(current_user.id)
      @user = current_user
    end
  end
end
