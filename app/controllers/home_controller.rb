class HomeController < ApplicationController
	#before_filter :authenticate
	caches_action :index, :about, :terms

	def index
		@page_caching = true
	end

	def about
		@page_caching = true
	end

	def terms
		@page_caching = true
	end

	protected

	def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == "damian" && password == "shroom"
    end
  end
end
