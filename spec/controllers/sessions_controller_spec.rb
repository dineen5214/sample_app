require 'spec_helper'

describe SessionsController do

  render_views

  describe "GET 'new'" do

    it "should be successful" do
      get 'new'
      response.should be_success
    end

    it "should have the right title" do
        post :new
        response.should  have_selector('title', :content => "Sign in")
    end
  end

  describe "POST 'create'" do
    
    describe "failure" do

      before(:each) do
        @attr = { :email => "", :password => "" }
      end

      it "should re-render the new page" do
        post :create, :session => @attr
        response.should  render_template('new')
      end

      it "should have the right title" do
        post :create, :session => @attr
        response.should  have_selector('title', :content => "Sign in")
      end

      it "should have an error message" do
        post :create, :session => @attr
        flash.now[:error].should =~ /invalid/i
      end
    end

    describe "success" do

      # we want a before block to describe some Attributes used during success block
      before(:each) do
        @user = Factory(:user)
        # attr hash for user's email and pass
        # the 'Factory' sets the attr_accessor :password in the user.rb
        @attr = { :email => @user.email, :password => @user.password }
      end

      it "should sign the user in" do
        post :create, :session => @attr
        # Fill in with tests for a signed-in user.
        controller.current_user.should == @user
        controller.should be_signed_in           #calling be_signed_in should be be_singed_in bollearn ?
      end

      it "should redirect to the user show page" do
        post :create, :session => @attr
        response.should redirect_to(user_path(@user))      # remember in rspec we have to user_path
      end
    end

  end  # POST create
end
