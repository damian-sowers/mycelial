class ProjectsController < ApplicationController

	before_filter :authenticate_user!, except: [:show, :index]
	before_filter :correct_user, only: [:edit, :update, :destroy, :delete_picture, :change_order]
	before_filter :get_sidebar_info, except: [:index, :show]

	def show
		@project = Project.find(params[:id])
		@page = @project.page
		@user = @page.user
		@user_projects = Project.find_all_by_page_id(@page.id)

		#get the tech tags for this project
		@tag_ids = Tagowner.find_all_by_project_id(params[:id])

		@tech_tags = Array.new
		@tag_ids.each do |f|
			#query for the rows associated with with these ids
			@tech_tags << TechTag.find(f.tech_tag_id)
		end
		#show edit blocks on hover if page_owner == 1
		@page_owner = is_page_owner?(@project.id)
		@comments = @project.comments.arrange(:order => :created_at)
		#get likes count for the right sidebar. 
		@likes_count = Like.count(:all, :conditions => ["project_id = ?", params[:id]])
	end

	def new_project 
	end

	def new
		@project = Project.new
	end

	def create
		@project = Project.new(params[:project])
		@project.page_id = Page.find_by_user_id(current_user.id).id
		#need to get a count of the total projects this user has. Then make the order of this project  = count + 1. 
		@project.page_order = Page.find_by_user_id(current_user.id).projects.count + 1

		tech_tag_tokens = params[:project][:tech_tag_tokens]
		if tech_tag_tokens
			@project.tag_list = turn_tag_ids_into_name_string(tech_tag_tokens)
		end

		if @project.save
			flash[:success] = "Your project has been created."
			redirect_to :controller => "pages", :action => "show", :id => current_user.username, only_path: true
		end
	end

	def edit
		@project = Project.find(params[:id])
		#going to have to differentiate all the editable fields below. Maybe get the value of the param. 
		#like edit_block = 'short_description'. try render :partial => '#{params[:edit_block]}'
		if params[:edit_block]
			#run through switch to find out edit block to render. Need to do it this way for security. Can't pass param into render
			edit_block = get_edit_block(params[:edit_block])
			unless edit_block.nil?
				if edit_block == "tech_tags"
					render "tech_tags"
				else 
					#render partial doesn't load the head css data, etc...
					render :partial => edit_block
				end
			end
		end
	end

	def update
		@project = Project.find(params[:id])
		
		#get the tags from the attributes and pass it into tag_list. 
		tech_tag_tokens = params[:project][:tech_tag_tokens]
		if tech_tag_tokens
			@project.tag_list = turn_tag_ids_into_name_string(tech_tag_tokens)
		end

		if @project.update_attributes(params[:project]) 
      flash[:success] = "Project updated"
      redirect_to :action => "edit", :id => params[:id], only_path: true
    else 
      render 'edit'
    end
	end

	def destroy
		#get the user page id
		@page_id = User.find(current_user.id).page.id
		project = Project.find(params[:id])
		if project.destroy
			flash[:success] = "Project Deleted"
      redirect_to :controller => "pages", :action => "edit", :id => @page_id, only_path: true
		else
			flash[:error] = "Something went wrong"
			redirect_to :controller => "pages", :action => "edit", :id => @page_id, only_path: true
		end
	end

	def project_type
		@project_type = params[:id]
		respond_to do |format|
			format.html 
      format.js { render :layout => false }
    end
	end

	def project_layout
		@project = Project.new
		@project_type = params[:project_type]
		@widget_type = params[:widget_type]
		respond_to do |format|
			format.html
      format.js { render :layout => false }
    end
	end

	def delete_picture
		r = Project.find(params[:id])
		r.remove_picture!
		r.remove_picture = true
		r.save
		respond_to do |format|
			format.html
      format.js { render :layout => false }
    end
	end

	def change_order
		#needs to update the projects table to change the order of the project above it and the project itself. Maybe I need to send the current order in a get var. Do this by the iteration of the loop
		@projects = current_user.page.projects.order("page_order ASC")
		current_order = params[:current_order].to_i

		first_project = Project.find_by_page_order(current_order - 1)
		first_project.page_order = current_order

		second_project = Project.find(params[:id])
		second_project.page_order = second_project.page_order - 1

		if verify_order_of_projects(first_project.page_order, second_project.page_order)
			Project.transaction do
				if first_project.save && second_project.save
					render :toggle
				end
			end
		end
	end

	private

		def get_user
    	@user = Project.find(params[:id]).page.user
    end    

    def count_subarrays array
		  return 0 unless array && array.is_a?(Array)

		  nested = array.select { |e| e.is_a?(Array) }
		  if nested.empty?
		    1 # this is a leaf
		  else
		    nested.inject(0) { |sum, ary| sum + count_subarrays(ary) }
		  end
		end

		def turn_tag_ids_into_name_string(tech_tag_tokens)
			#will be a csv string of tech_tag_ids. Need to get all of their names. 
			#turn them into array and then perform map on each value in array to turn into integer.
			tag_name_array = []
			tech_tag_tokens.split(",").each do |x|
				if x.include?("<<<")
					tag_name_array << x.gsub(/[<>]/i, '')
				end
			end
			#now see if there are any new tags in there (will be in format "<<<tag name>>>"). 
			#the function below tests every value in the array to see if integer, if no it sets to nil and removes from the array.
			tag_ids = tech_tag_tokens.split(",").map { |s| Integer(s) rescue nil }.compact
			#now query Tagowner for the name and put into an array. Then join the array into a string with commas separating them. 
			tag_ids.each do |t|
				tag_name_array << TechTag.find(t).name
			end
			tag_list = tag_name_array.join(", ")
		end

		def get_edit_block(edit_block)
			case edit_block
				when "short_description"
					return "short_description"
				when "long_description"
					return "long_description"
				when "tech_tags"
					return "tech_tags"
				when "other_interesting"
					return "other_interesting"
				when "project_links"
					return "project_links"
				else 
					return nil
			end
		end

		def verify_order_of_projects(first_page_order, second_page_order)
			second_page_order > 0 && first_page_order > 1 && first_page_order != second_page_order
		end
end
