require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/invitations/new.html.haml" do
  include ApplicationHelper


  describe "without login" do

    before(:each) do
      user = Factory(:user)
      @news_item = Factory(:tip, :user=>user)
      @invitation = make_invitation(nil, @news_item)
      assigns[:invitation] = @invitation
    end

    it "should render new form with login linke" do
      render "/invitations/new.html.haml"

      response.should have_tag("a[href=?]", "/session/new")
    end

  end

  describe "with loged on user" do

    before(:each) do
      @user = Factory(:user)
      @news_item = Factory(:tip, :user=>@user)
      @invitation = make_invitation(@user, @news_item)
      assigns[:invitation] = @invitation
    end

    it "should render new form" do
      render "/invitations/new.html.haml"

      response.should have_tag("form#invitation_mail") do
        with_tag "input[type=hidden][name='invitation[news_item_id]'][value=#{@news_item.id}]"
        with_tag "textarea[name='invitation[email_addresses]']"
        with_tag "textarea[name='invitation[message]']"
        with_tag "#mail_message"
      end
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

