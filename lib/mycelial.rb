module Mycelial

  protected

		def sidebar_data(user_id)
			@page = Page.find_by_user_id(user_id)
		end

end