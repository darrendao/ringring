class CallEscalation < ActiveRecord::Base
  belongs_to :user
  belongs_to :call_list
  default_scope :order => 'position'
end
