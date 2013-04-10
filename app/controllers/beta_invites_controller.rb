class BetaInvitesController < ApplicationController

  def new
    @beta_invite = BetaInvite.new
  end

  def create
    @beta_invite = BetaInvite.new(params[:beta_invite])
    if @beta_invite.save
      flash[:success] = "Thanks for signing up."
      redirect_to :controller => "beta_invites", :action => "thanks", only_path: true
    else

    end
  end

  def thanks
  end
end
