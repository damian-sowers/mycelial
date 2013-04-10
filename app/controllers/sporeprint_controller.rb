class SporeprintController < ApplicationController

  before_filter :set_projects_per_page

  def show
    @total_projects = get_original_project(params[:id].to_i).find_related_tags
    #stupid array count doesn't work on this scope for some reason so I have to cycle through to count the number of objects.
    x = 0
    @total_projects.each do |f| 
      x += 1
    end

    @total_pages = (x.to_f / @projects_per_page.to_f).ceil

    if params[:offset]
      @offset = Integer(params[:offset]) + 1
      limit_num = (Integer(params[:offset]) + 1) * @projects_per_page
    else
      limit_num = @projects_per_page
    end

    @offset ||= 1

    @projects = find_related_projects(params[:id].to_i, limit_num)
    render 'pages/show'
  end

  def load_more

    offset = @projects_per_page * Integer(params[:offset])
    project_id = params[:project_id].to_i
    @projects = find_related_projects(project_id, @projects_per_page, offset)

    respond_to do |format|
      format.html { render :partial => 'pages/more_projects' }
      format.js { render :layout => false }
    end
  end

  private 

    def get_original_project(project_id)
      @original_project = Project.find(project_id)
    end

    def set_projects_per_page
      @projects_per_page = 20
    end

    def find_related_projects(project_id, limit_num, offset = 0)
      @related_projects = get_original_project(project_id).find_related_tags.limit(limit_num).offset(offset)
    end
end
