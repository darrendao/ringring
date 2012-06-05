class CallListOwner < ActiveRecord::Base
  belongs_to :call_list
  belongs_to :user
  validates :user_id, :uniqueness => {:scope => :call_list_id}
end
