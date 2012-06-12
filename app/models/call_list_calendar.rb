class CallListCalendar < ActiveRecord::Base
  belongs_to :call_list
  after_initialize :default_values

  private
  def default_values
    self.ctype ||= Ringring::Calendar::Type::LOCAL
  end
end
