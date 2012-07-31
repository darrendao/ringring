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

  # Return enumerator for oncall candidates and cycle over the
  # last person oncall
  def self.gen_candidates_enum(candidates, last_oncall_user)
    candidates_enum = candidates.cycle
    counter = 0
    begin
      oncall_candidate = candidates_enum.next
      if last_oncall_user == oncall_candidate
        break
      end
 
      counter += 1
    end until counter >= candidates.size
    return candidates_enum
  end
end
end
