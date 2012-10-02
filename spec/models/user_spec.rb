require "spec_helper"
require "cancan/matchers"

describe User do
  describe 'ability' do
    it "can manage their own call list" do
      call_list = CallList.make!(:name => 'my call list', :twilio_list_id => (rand * 2132).to_i)
      user = User.make!
      call_list.owners << user
      ability = Ability.new(user) 
      ability.should be_able_to(:manage, call_list)
    end

    it "cannot manage someone else's call list" do
      call_list = CallList.make!(:name => 'not my call list', :twilio_list_id => (rand * 2132).to_i)
      user = User.make!
      ability = Ability.new(user) 
      ability.should_not be_able_to(:manage, call_list)
    end
  end  
end
