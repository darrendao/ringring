class BusinessHour < ActiveRecord::Base
  belongs_to :call_list
  validates :wday, :presence => true
#  validates :call_list_id, :presence => true
  default_scope :order => 'wday'
end
