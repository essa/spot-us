require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/invitations/new.html.haml" do
  include ApplicationHelper

  before(:each) do
    @user = Factory(:user)
    @news_item = Factory(:tip, :user=>@user)
    @invitation = make_invitation(@user, @news_item)
    assigns[:invitation] = @invitation
  end

  it "should render new form" do
    render "/invitations/new.html.haml"

    p response.body
    response.should have_tag("form[action=?][method=post]", "/invitations/create") do
      with_tag "input[type=textarea][name=emails]"
    end
  end

  def make_invitation(user, news_item)
    invitation = Invitation.new
    invitation.sender = user
    invitation.news_item = news_item
    invitation.message = 'Check this'
    invitation
  end
end


