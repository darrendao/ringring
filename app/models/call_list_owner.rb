class CallListOwner < ActiveRecord::Base
  belongs_to :call_list
  belongs_to :user
end
