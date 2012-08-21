class BusinessHour < ActiveRecord::Base
#  before_validation :handle_timezone

  belongs_to :call_list
  validates :wday, :presence => true
  default_scope :order => 'wday'

  private
  def handle_timezone
    if start_time
      start_time = Time.zone.parse(start_time.to_s)
    end
    if end_time
      end_time = Time.zone.parse(end_time.to_s)
    end
  end
end
