require "spec_helper"
require "cancan/matchers"

describe CallListsController do
  describe "authorization" do
    it "should not allow users to delete or edit call list they don't own" do
      call_list = CallList.make!
      user = User.make!
      ability = Ability.new(user)
      assert ability.cannot?(:destroy, call_list)
      assert ability.cannot?(:update, call_list)
    end

    it "should allow users to delete and edit call lists that they own" do
      user = User.make!
      call_list = CallList.make!
      call_list.owners << user
      ability = Ability.new(user)
      assert ability.can?(:destroy, call_list)
      assert ability.can?(:update, call_list)
    end
  end
end
