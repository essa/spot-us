class InvitationsController < ApplicationController
  before_filter :login_required

  def new
    @invitation = make_invitation(params[:invitation])
  end

  def validate
    @invitation = make_invitation(params[:invitation])
    if @invitation.valid?
    else
      flash[:error] = "email error"
    end
  end

  def create
    @invitation = make_invitation(params[:invitation])
    if @invitation.valid?
      @invitation.send_email
    else
      flash[:error] = "email error"
    end
  end

  private

  def make_invitation(params)
    invitation = Invitation.new
    invitation.sender = current_user
    invitation.news_item = NewsItem.find(params[:news_item_id])
    invitation.email_addresses_text = params[:email_addresses].to_s
    invitation.message = params[:message]
    invitation
  end
end
