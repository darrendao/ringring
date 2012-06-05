class CallListMembership < ActiveRecord::Base
  belongs_to :user
  belongs_to :call_list
  validates :user_id, :uniqueness => {:scope => :call_list_id}
  after_destroy :cleanup_call_list

  private
  def cleanup_call_list
    CallEscalation.where(:call_list_id => call_list_id, :user_id => user_id).destroy_all
    OncallAssignment.where(:call_list_id => call_list_id, :user_id => user_id).destroy_all
  end
end
