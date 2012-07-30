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
end
