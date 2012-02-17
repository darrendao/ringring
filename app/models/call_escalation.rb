class CallEscalation < ActiveRecord::Base
  default_scope :order => "position"
end
