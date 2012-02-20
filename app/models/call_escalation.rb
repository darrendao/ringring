class CallEscalation < ActiveRecord::Base
  belongs_to :user
  default_scope :order => 'position'
end
