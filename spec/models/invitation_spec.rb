require File.dirname(__FILE__) + '/../spec_helper'

describe Invitation do

  before(:each) do
    @user = Factory(:user)
    @news_item = Factory(:news_item, :user => @user)
  end

  it 'has 4 attributes, sender, newsitem, email_addresses_text and message'do
    invitation = Invitation.new
    invitation.sender = @user
    invitation.news_item = @news_item
    invitation.email_addresses_text = 'tnakajima@brain-tokyo.jp'
    invitation.message = 'Check this'
    invitation.should be_valid
  end

  it 'requires sender, email_addresses_text and newsitem' do
    invitation = Invitation.new
    invitation.should_not be_valid
    invitation.errors.on(:sender).should_not be_nil
    invitation.errors.on(:email_addresses_text).should_not be_nil
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

  describe 'parsing email addresses' do
    it 'can detect error on email_addresses_text' do
      error_addresses = [
                         'tnakajima@brain-tokyo.jp,@a',
                         '',
                         'tnakajima',
                         'tnakajima@',
                         '@brain-tokyo.jp',
                         'tnakajima@brain-tokyo.jp,',
                         'tnakajima@brain-tokyo.jp,a',
                        ]
      error_addresses.each do |a|
        begin
          invitation = make_invitation
          invitation.email_addresses_text = a
          invitation.should_not be_valid
          invitation.errors.on(:email_addresses_text).should_not be_nil
        rescue
          STDERR.puts "an exception raised at parsing #{a}"
          p Regexp.last_match
          raise
        end
      end
    end

    it 'can parse one email_addresse' do
      invitation = make_invitation
      invitation.email_addresses_text = 'tnakajima@brain-tokyo.jp'
      invitation.should be_valid

      # ??? "should have " causes a DEPRECATION WARNING, I can't figure out why'
      #invitation.should have(1).emails

      invitation.emails[0].should == 'tnakajima@brain-tokyo.jp'
    end

    it 'can parse two email_addresses' do
      invitation = make_invitation
      invitation.email_addresses_text = 'tnakajima@brain-tokyo.jp, dcohn1@gmail.com'
      invitation.should be_valid
      #invitation.should have(2).emails
      invitation.emails[0].should == 'tnakajima@brain-tokyo.jp'
      invitation.emails[1].should == 'dcohn1@gmail.com'
    end

    it 'can parse three email_addresses' do
      invitation = make_invitation
      invitation.email_addresses_text = 'tnakajima@brain-tokyo.jp, dcohn1@gmail.com, desi@hashrocket.com'
      invitation.should be_valid
      #invitation.should have(3).emails
      invitation.emails[0].should == 'tnakajima@brain-tokyo.jp'
      invitation.emails[1].should == 'dcohn1@gmail.com'
      invitation.emails[2].should == 'desi@hashrocket.com'
    end

    def make_invitation
      invitation = Invitation.new
      invitation.sender = @user
      invitation.news_item = @news_item
      invitation.message = 'Check this'
      invitation
    end
  end
end


