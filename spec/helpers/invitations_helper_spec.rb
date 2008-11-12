require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "/invitations/new.html.haml" do
  include ApplicationHelper
  include InvitationsHelper

  before(:each) do
    @user = Factory(:user)
    @news_item = Factory(:tip, :user=>@user)
  end

  it "has a method for pre_written copy of a message" do
    m = pre_written_message(@news_item)
    m.should match %r[http://spot.us/news_items/#{@news_item.id}]
  end
end
