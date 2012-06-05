class CallListMembership < ActiveRecord::Base
  belongs_to :user
  belongs_to :call_list
  validates :user_id, :uniqueness => {:scope => :call_list_id}
end
