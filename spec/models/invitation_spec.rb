require File.dirname(__FILE__) + '/../spec_helper'

describe Invitation do

  before(:each) do
    @user = Factory(:user)
    @news_item = Factory(:news_item, :user => @user)
  end

  it 'has 4 attributes, sender, newsitem, emails and message'do
    invitation = Invitation.new
    invitation.sender = @user
    invitation.news_item = @news_item
    invitation.emails = 'tnakajima@brain-tokyo.jp'
    invitation.message = 'Check this'
    invitation.should be_valid
  end

  it 'requires sender, emails and newsitem' do
    invitation = Invitation.new
    invitation.should_not be_valid
    invitation.errors.on(:sender).should_not be_nil
    invitation.errors.on(:emails).should_not be_nil
    invitation.errors.on(:news_item).should_not be_nil
  end

  it 'requires sender be a User' do
    invitation = Invitation.new
    invitation.sender = 'should be NewsItem'
    invitation.should_not be_valid
    invitation.errors.on(:sender).should_not be_nil
  end

  it 'requires newsitem be a NewsItem' do
    invitation = Invitation.new
    invitation.news_item = 'should be NewsItem'
    invitation.should_not be_valid
    invitation.errors.on(:news_item).should_not be_nil
  end
end


