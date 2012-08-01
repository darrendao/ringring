require "spec_helper"

describe "oncall assignment generator" do
  it "generate candidates_enum with correct position" do
    user1 = User.create(:email => 'user1@example.com', :password => 'password')
    user2 = User.create(:email => 'user2@example.com', :password => 'password')
    user3 = User.create(:email => 'user3@example.com', :password => 'password')
    user4 = User.create(:email => 'user3@example.com', :password => 'password')
    candidates = [user1, user2, user3]
   
    enum = Ringring::OncallAssignmentsGenerator::gen_candidates_enum(candidates, user1)
    enum.next.should eq(user2)
    enum.next.should eq(user3)

    enum = Ringring::OncallAssignmentsGenerator::gen_candidates_enum(candidates, user3)
    enum.next.should eq(user1)

    enum = Ringring::OncallAssignmentsGenerator::gen_candidates_enum(candidates, user4)
    enum.next.should eq(user1)
  end

  it "returns correct next oncall date for a given cycle" do
    day1 = DateTime.new(2012, 07, 30)   # Monday
    next_day = Ringring::OncallAssignmentsGenerator::next_oncall_cycle(day1, Date::ABBR_DAYNAMES.index('Mon'))
    next_day.should eq(DateTime.new(2012, 8, 6))

    next_day = Ringring::OncallAssignmentsGenerator::next_oncall_cycle(day1, Date::ABBR_DAYNAMES.index('Sat'))
    next_day.should eq(DateTime.new(2012, 8, 4))

    day2 = DateTime.new(2012, 8, 1)   # Wed
    next_day = Ringring::OncallAssignmentsGenerator::next_oncall_cycle(day1, Date::ABBR_DAYNAMES.index('Mon'))
    next_day.should eq(DateTime.new(2012, 8, 6))
  end
end
