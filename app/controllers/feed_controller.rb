class FeedController < ApplicationController

	def index
		time = Time.now.to_i

		if params[:tag]
			@projects = Project.find(:all, :conditions => ["tagowners.tech_tag_id = ?", params[:tag]], :joins => {:tagowners => {}}, :order => get_feed_algorithm())
		else 
			@projects = get_projects(20)
		end

		total_projects = @projects.count
		@total_pages = 1
		render 'pages/show'
	end

	private

		def get_feed_algorithm
			@algo = "(((projects.likes_count + 1) / (1/strftime(projects.created_at)))) DESC"
		end

		def get_projects(limit_num)
			projects = Project.order(get_feed_algorithm()).limit(limit_num)
		end
end
