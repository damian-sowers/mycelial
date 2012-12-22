class FeedController < ApplicationController
	before_filter :set_projects_per_page

	def index
		time = Time.now.to_i

		if params[:offset]
			@offset = Integer(params[:offset]) + 1
			limit_num = (Integer(params[:offset]) + 1) * @projects_per_page
		else
			limit_num = @projects_per_page
		end

		if params[:tag] && params[:tag] != ""
			#first query to see if a tag exists with that string name. If so, get the tag id and pass to the method below. 
			@tag = get_existing_tag_by_name(params[:tag])

			if @tag
				@total_projects = count_total_tag_specific_projects(@tag.id)
				@projects = get_tag_specific_projects(@tag.id, limit_num)
			else 
				@total_projects = 0
				#need to include a message here saying no projects were found with this tag name
				@projects = []
			end
		else 
			@total_projects = count_total_projects()
			@projects = get_projects(limit_num)
		end
		
		@offset ||= 1
		@total_pages = (@total_projects.to_f / @projects_per_page.to_f).ceil
	
		render 'pages/show'
	end

	def load_more

		offset = @projects_per_page * Integer(params[:offset])

		if params[:tag] && !params[:tag].empty?
			#first query to see if a tag exists with that string name. If so, get the tag id and pass to the method below. 
			@tag = get_existing_tag_by_name(params[:tag])

			if @tag
				@projects = get_tag_specific_projects(@tag.id, @projects_per_page, offset)
			else 
				#need to include a message here saying no projects were found with this tag name
				@projects = []
			end
		else 
			@projects = get_projects(@projects_per_page, offset)
		end

		respond_to do |format|
			format.html { render :partial => 'pages/more_projects' }
      format.js { render :layout => false }
    end
	end

	private

		def set_projects_per_page 
			@projects_per_page = 10
		end

		def get_feed_order_algorithm
			if Rails.env.development?  
				string = "(((projects.likes_count + 1) / (1/strftime(projects.created_at)))) DESC"
			else 
				string = "((projects.likes_count + 1) / (extract(epoch from projects.created_at))) DESC"
			end
		end

		def get_projects(limit_num, offset = 0)
			projects = Project.order(get_feed_order_algorithm()).limit(limit_num).offset(offset)
		end

		def count_total_projects
			projects = Project.count(:all)
		end

		def get_tag_specific_projects(tag, limit_num, offset = 0)
			projects = Project.find(:all, :conditions => ["tagowners.tech_tag_id = ?", tag], :joins => {:tagowners => {}}, :order => get_feed_order_algorithm(), :limit => limit_num, :offset => offset)
		end

		def count_total_tag_specific_projects(tag)
			projects = Project.count(:all, :conditions => ["tagowners.tech_tag_id = ?", tag], :joins => {:tagowners => {}})
		end

		def get_existing_tag_by_name(name)
			tag = TechTag.find(:first, :conditions => ["lower(name) = ?", name.downcase])
		end
end
