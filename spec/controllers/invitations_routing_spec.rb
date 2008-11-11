require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe InvitationsController do
  describe "routes" do
    route_matches("/invitations/new",    :get, :controller => "invitations", :action => "new")
    route_matches("/invitations/validate", :post, :controller => "invitations", :action => "validate")
    route_matches("/invitations", :post, :controller => "invitations", :action => "create")
  end
end
