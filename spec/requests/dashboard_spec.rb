require "spec_helper"

describe "Dash Board" do
  it "displays the username after successful login" do
    User.create(:email => 'admin@example.com', :password => 'password')

    visit "/users/sign_in"
    fill_in "user[email]", :with => 'admin'
    fill_in "user[password]", :with => 'password'
    click_button "Sign in"

    page.should have_content("Logged in as admin")
  end

  it "redirects to login page after unsuccessful login" do
    
  end

  it "displays call lists that the user belongs to" do

  end

  it "displays the user's current oncall assignments if there are any" do

  end
end
