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
    User.create(:email => 'admin@example.com', :password => 'password')

    visit "/users/sign_in"
    fill_in "user[email]", :with => 'admin'
    fill_in "user[password]", :with => 'wrongpassword'
    click_button "Sign in"

    page.should_not have_content("Logged in as admin")
    
  end

  it "displays call lists that the user belongs to" do
    user = User.create(:email => 'admin@example.com', :password => 'password')
    call_list = CallList.make!(:name => 'my special call list')
    call_list.owners << user    

    CallList.make!(:name => 'someone else call list')

    visit "/users/sign_in"
    fill_in "user[email]", :with => 'admin'
    fill_in "user[password]", :with => 'password'
    click_button "Sign in"
    
    page.should have_content("my special call list")
    page.should_not have_content("someone else call list")
  end

  it "displays the user's current oncall assignments if there are any"
end
