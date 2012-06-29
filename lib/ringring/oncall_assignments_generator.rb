module Ringring
class OncallAssignmentsGenerator

  # Given a date, figure out when's the next time we'll change oncall assignment
  # cycle_day is a wday integer that specifies when the oncall cycle changes
  def self.next_oncall_cycle(date, cycle_day)
    begin
      date += 1.day
    end until date.wday == cycle_day 
    return date
  end
end
end
