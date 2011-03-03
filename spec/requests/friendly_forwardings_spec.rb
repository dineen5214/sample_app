require 'spec_helper'

describe "FriendlyForwardings" do

  it "should forward to the requested page after signin" do
    user = Factory(:user)
    visit edit_user_path(user)
    fill_in  :email, :with => user.email
    fill_in  :password, :with => user.password
    click_button

    response.should  render_template('users/edit')
    visit signout_path                               # this is redirect back to the HOME page
    visit signin_path                                # back to sign in
    fill_in  :email, :with => user.email
    fill_in  :password, :with => user.password
    click_button

    response.should  render_template('users/show')    # to the show page
  end
end
