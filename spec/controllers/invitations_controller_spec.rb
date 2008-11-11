require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe InvitationsController do

  #Delete this example and add some real ones
  it "should use InvitationsController" do
    controller.should be_an_instance_of(InvitationsController)
  end

  before(:each) do
    @user = Factory(:user)
    @news_item = Factory(:tip, :user=>@user)
  end

  describe "when not logged on" do
    before(:each) do
      get :new, :news_item_id=>@news_item.id
    end
    it_denies_access
  end

  describe "on GET to /tips/new" do
    before(:each) do
      controller.stub!(:current_user).and_return(@user)
      get :new, :invitation => { :news_item_id=>@news_item.id }
    end

    it "assigns invitation with specified news_item" do
      response.should be_success
      response.should render_template('new')
      assigns(:invitation).should_not be_nil
      assigns(:invitation).should be_kind_of(Invitation)
      assigns(:invitation).sender.id.should == @user.id
      assigns(:invitation).news_item.id.should == @news_item.id
    end
  end

  describe "on validating e-mail addresses" do
    before(:each) do
      controller.stub!(:current_user).and_return(@user)
    end

    it "should validate a valid e-mail addresse" do
      post :validate, :invitation => { :news_item_id=>@news_item.id, :email_addresses=>"tnakajima@brain-tokyo.jp" }
      response.should be_success
      flash[:error].should be_nil
    end

    it "report an error if an invalid e-mail addresse is posted" do
      post :validate, :invitation => { :news_item_id=>@news_item.id, :email_addresses=>"should be email address" }
      response.should be_success
      flash[:error].should_not be_nil
    end
  end

  describe "on sending e-mails" do
    before(:each) do
      controller.stub!(:current_user).and_return(@user)
    end

    it "should send a e-mail" do
      Mailer.should_receive(:deliver_invitation_mail).once
      post :create, :invitation => { :news_item_id=>@news_item.id, :email_addresses=>"tnakajima@brain-tokyo.jp" }
      response.should be_success
      flash[:error].should be_nil
    end

    it "report an error if an invalid e-mail addresse is posted" do
      Mailer.should_not_receive(:deliver_invitation_mail)
      post :create, :invitation => { :news_item_id=>@news_item.id, :email_addresses=>"should be email address" }
      response.should be_success
      flash[:error].should_not be_nil
    end
  end
end
