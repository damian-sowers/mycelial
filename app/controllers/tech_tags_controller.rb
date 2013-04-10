class TechTagsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_sidebar_info
  before_filter :only_admin_allowed, only: [:new, :create]

  def index
    @tags = TechTag.order(:name)
    #render :text => @tech_tags.name
    respond_to do |format|
      format.html
      format.json { render json: @tags.tokens(params[:q]) }
    end
  end

  def show 
    @tech_tag = TechTag.find(params[:id])
  end

  def new
    @tech_tags = TechTag.new
  end

  def create
    @tech_tags = TechTag.new(params[:tech_tag])
    if @tech_tags.save
      flash[:success] = "New tag has been added"
      redirect_to :controller => "tech_tags", :action => "index", only_path: true
    end
  end
end
