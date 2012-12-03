class ProjectsController < ApplicationController

	before_filter :authenticate_user!, except: [:show, :index]
	before_filter :correct_user, only: [:edit, :update, :destroy]
	before_filter :get_sidebar_info, except: [:index, :show]

	def index
	end

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
	end

	def new_project 
	end

	def new
		@project = Project.new
	end

	def create
		@project = Project.new(params[:project])
		@project.page_id = Page.find_by_user_id(current_user.id).id
		if @project.save
			flash[:success] = "Your project has been created."
			redirect_to :action => "edit", :id => @project.id, only_path: true
		end
	end

	def edit
		@project = Project.find(params[:id])
		#going to have to differentiate all the editable fields below. Maybe get the value of the param. 
		#like edit_block = 'short_description'. try render :partial => '#{params[:edit_block]}'
		if params[:edit_block]
			if params[:edit_block] == "tech_tags"
				render "tech_tags"
			else 
				#render partial doesn't load the head css data, etc...
				render :partial => "#{params[:edit_block]}"
			end
		end
	end

	def update
		@project = Project.find(params[:id])
		if @project.update_attributes(params[:project]) 
      flash[:success] = "Project updated"
      redirect_to :action => "edit", :id => params[:id], only_path: true
    else 
      render 'edit'
    end
	end

	def destroy
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
end
