class StatusController < ApplicationController
	before_filter :authenticate

	def index
	end

	protected

	def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == "damian" && password == "shroom"
    end
  end
end
