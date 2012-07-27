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
end
