require 'spec_helper'

describe CallList do
  describe "default factory creation" do
    it "can be created" do
      call_list = CallList.make
      #call_list.valid?
      #puts call_list.errors.full_messages.inspect
      call_list.should be_valid
    end
  end

  describe "validate required field" do
    it "is invalid if name is not provided" do
      call_list = CallList.make(:name => nil)
      call_list.should have(1).errors_on(:name)
    end

    it "is invalid without any owner" do
      call_list = CallList.make(:call_list_owners => [])
      call_list.should have(1).errors_on(:call_list_owners)
    end

    it "cannot have same name as existing call list" do
      CallList.make!(:name => "calllist1")
      call_list = CallList.make(:name => "calllist1")
      call_list.should_not be_valid
      call_list.should have(1).errors_on(:name)
    end
  end

  describe "last_oncall helper methods" do
    before(:each) do
      @user1 = User.make!(:email => 'auser1@example.com', :password => 'password')
      @user2 = User.make!(:email => 'auser2@example.com', :password => 'password')
      @user3 = User.make!(:email => 'auser3@example.com', :password => 'password')
      @call_list = CallList.make!
    end
    
    it "returns nil if there is no oncall assignments in the past" do
      # assignment that is in the future
      oncall_assignment = OncallAssignment.make!(:user_id => @user3.id,
                                                 :call_list_id => @call_list.id,
                                                 :starts_at => DateTime.now + 1,
                                                 :ends_at => DateTime.now + 3
                                                )
      @call_list.last_oncall(DateTime.now).should equal(nil)
    end

    it "returns last oncall correctly" do
      oncall_assignment = OncallAssignment.make!(:user_id => @user2.id,
                                                 :call_list_id => @call_list.id,
                                                 :starts_at => DateTime.now - 7,
                                                 :ends_at => DateTime.now - 2
                                                )
      @call_list.last_oncall(DateTime.now).should eq(@user2)

      oncall_assignment = OncallAssignment.make!(:user_id => @user1.id,
                                                 :call_list_id => @call_list.id,
                                                 :starts_at => DateTime.now - 7,
                                                 :ends_at => DateTime.now + 2
                                                )
      @call_list.last_oncall(DateTime.now).should eq(@user1)
      @call_list.last_oncall(DateTime.now).should eq(@user1)
    end

    it "returns last oncall correctly when passing in datetime in future" do
      # assignment that is in the future
      oncall_assignment = OncallAssignment.make!(:user_id => @user3.id,
                                                 :call_list_id => @call_list.id,
                                                 :starts_at => DateTime.now + 1,
                                                 :ends_at => DateTime.now + 3
                                                )
      @call_list.last_oncall(DateTime.now + 2).should eq(@user3)
    end
  end

  describe "verify oncall auto-assignment" do
    before(:each) do
      @user1 = User.make!(:email => 'auser1@example.com', :password => 'password')
      @user2 = User.make!(:email => 'auser2@example.com', :password => 'password')
      @user3 = User.make!(:email => 'auser3@example.com', :password => 'password')
      @users = [@user1, @user2, @user3]
      @call_list = CallList.make!

      @users.each do |user| 
        CallListMembership.create(:call_list_id => @call_list.id,
                                  :user_id => user.id,
                                  :oncall_candidate => true)
      end
    end
    it "raises exception if auto-assignment is not enabled" do 
      lambda {@call_list.gen_oncall_assignments}.should raise_error 
    end

    it "generates oncall assignments correctly for the first time" do
      oncall_assignments_gen = OncallAssignmentsGen.make!
      @call_list.oncall_assignments_gen = oncall_assignments_gen
      @call_list.save

      lambda {@call_list.gen_oncall_assignments}.should_not raise_error 
      @call_list.oncall_assignments.size.should be == AppConfig.oncall_assignments_gen['from_now'] + 1
      @call_list.oncall_assignments_gen.last_gen.should be > AppConfig.oncall_assignments_gen['from_now'].weeks.from_now
      @call_list.oncall_assignments.last.starts_at.should_not be > AppConfig.oncall_assignments_gen['from_now'].weeks.from_now
      last_oncall = nil
   
      @call_list.oncall_assignments.first.user.should eq(@user1)
      @call_list.oncall_assignments.each do |ass|
        ass.user.should_not eq(last_oncall)
        last_oncall = ass.user
      end
    end

    it "generates subsequent oncall assignments correctly" do
      oncall_assignments_gen = OncallAssignmentsGen.make!
      @call_list.oncall_assignments_gen = oncall_assignments_gen
      @call_list.save
      lambda {@call_list.gen_oncall_assignments(DateTime.now, 2)}.should_not raise_error
      @call_list.oncall_assignments.size.should be == 3
      @call_list.oncall_assignments.last.user.should eq(@user3)

      lambda {@call_list.gen_oncall_assignments(nil, 3)}.should_not raise_error
      @call_list.oncall_assignments.size.should be == 4
      @call_list.oncall_assignments.last.user.should eq(@user1)
    end

    it "only includes those who had been marked as candidates for oncalls" do
      non_oncall_user = User.make!
      CallListMembership.create(:call_list_id => @call_list.id,
                                :user_id => non_oncall_user.id,
                                :oncall_candidate => false)

      oncall_assignments_gen = OncallAssignmentsGen.make!
      @call_list.oncall_assignments_gen = oncall_assignments_gen
      lambda {@call_list.gen_oncall_assignments}.should_not raise_error
      @call_list.oncall_assignments.map{|ass|ass.user}.should_not include(non_oncall_user) 
      @call_list.oncall_assignments.map{|ass|ass.user}.should include(@user1) 
    end

    it "has correct oncall_candidates default ordering based on position" do
      call_list = CallList.make!
      @users.each_with_index do |user, index|
        CallListMembership.create(:call_list_id => call_list.id,
                                  :user_id => user.id,
                                  :position => @users.size - index,
                                  :oncall_candidate => true)
      end
      call_list.oncall_candidates.first.should eq(@users.last)
    end
  end

  describe "verify business hours" do
    it "is not in business hour if no business hours are defined" do
      call_list = CallList.make!
      call_list.in_business_hours?.should be_false
    end
    it "correctly determines if in business hour for UTC time" do
      call_list = CallList.make!(:business_time_zone => 'UTC')
      (0..6).each do |wday|
        call_list.business_hours.create(:wday => wday, :start_time => Time.parse("8:00 AM +0000"),
                                        :end_time => Time.parse("8:00 PM +0000"))
      end
      call_list.in_business_hours?(Time.parse("9:00 AM +0000")).should be_true
    end
    it "correctly determines if in business hour for non UTC time" do
      call_list = CallList.make!(:business_time_zone => 'Arizona')
      (0..6).each do |wday|
        call_list.business_hours.create(:wday => wday, :start_time => Time.parse("8:00 AM -0700"),
                                        :end_time => Time.parse("8:00 PM -0700"))
      end
      call_list.in_business_hours?(Time.parse("9:00 AM -0700")).should be_true
    end
  end

  describe "oncall assignment" do
    it "automatically add oncall user to membership list" do
      user1 = User.make!(:email => 'auser1@example.com', :password => 'password')
      call_list = CallList.make!
      oncall_assignment = OncallAssignment.make!(:user_id => user1.id,
                                                 :call_list_id => call_list.id)
      call_list.members.should include(user1)
      call_list.oncall_candidates.should include(user1)
    end
  end
end
