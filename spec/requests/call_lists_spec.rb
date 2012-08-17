require "spec_helper"

describe "Call Lists" do
  before(:each) do
    @admin_user = User.create(:email => 'admin@example.com', :password => 'password')
    visit "/users/sign_in"
    fill_in "user[email]", :with => 'admin'
    fill_in "user[password]", :with => 'password'
    click_button "Sign in"
  end
  
  describe "GET /call_lists" do
    it "displays call lists" do
      CallList.make!(:name => "calllist1")
      CallList.make!(:name => "calllist2")
      visit call_lists_path
      page.should have_content("calllist1")
      page.should have_content("calllist2")
    end
  end

  describe "POST /call_lists" do
    it "creates call list" do
      visit new_call_list_path
      fill_in "call_list[name]", :with => 'calllist3'
      click_button "Create Call list"
      page.should have_content("calllist3")
    end

    it "creates and displays call list with correct time display" do
      @admin_user.time_zone = "Mountain Time (US & Canada)"
      @admin_user.save
      visit new_call_list_path
      fill_in "call_list[name]", :with => 'calllist3'
      fill_in "call_list[business_hours_attributes][0][start_time]", :with => "9:15 AM"
      fill_in "call_list[business_hours_attributes][0][end_time]", :with => "7:32 PM"
      fill_in "call_list[oncall_assignments_gen_attributes][cycle_time]", :with => "1:23 AM"
      click_button "Create Call list"
      call_list_id = File.basename(current_path)
      page.should have_content('9:15')
      page.should have_content('7:32')
      page.should have_content('1:23')

      @admin_user.time_zone = "Central Time (US & Canada)"
      @admin_user.save
      visit(current_path)
      page.should have_content('10:15')
      page.should have_content('8:32')
      page.should have_content('2:23')

      actual_time = CallList.find(call_list_id).business_hours.first.start_time.in_time_zone('Mountain Time (US & Canada)')
      utc_time = Time.parse('9:15 UTC')
      assert actual_time == utc_time - actual_time.utc_offset
    end
  end

  describe "UPDATE call list"
end