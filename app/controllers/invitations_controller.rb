class InvitationsController < ApplicationController
  include InvitationsHelper
  before_filter :check_params

  def new
    @invitation = make_invitation(params[:invitation])
    store_location
  end

  def validate
    @invitation = make_invitation(params[:invitation])
    if @invitation.valid?
      display_message(:valid)
    else
      display_message(:invalid)
    end
  end

  def create
    sent = false
    @invitation = make_invitation(params[:invitation])
    if @invitation.valid?
      @invitation.send_email
      display_message(:sent)
      sent = true
    end
  ensure
    display_message(:error) unless sent
  end

  private

  def check_params
    if params[:invitation].blank?
      render_not_found
      false
    else
      @news_item = NewsItem.find(params[:invitation][:news_item_id])
      true
    end
  rescue ActiveRecord::RecordNotFound
    render_not_found
    false
  end

  def render_not_found
      render :file => "#{RAILS_ROOT}/public/404.html",
             :status => "404 Not Found"
  end


  def make_invitation(params)
    invitation = Invitation.new
    invitation.sender = current_user
    invitation.news_item = @news_item
    invitation.email_addresses_text = params[:email_addresses].to_s
    invitation.message = params[:message]
    invitation
  end

  def display_message(message_id)
    message = Messages[message_id]
    raise "can't happen. invalid message_id #{message_id}" unless message
    render(:update) do |page|
      page.replace_html :mail_message, message
    end
  end
end
