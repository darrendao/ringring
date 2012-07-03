class CallListMembership < ActiveRecord::Base
  default_scope :order => 'position'
  belongs_to :user
  belongs_to :call_list
  validates :user_id, :uniqueness => {:scope => :call_list_id}
  after_destroy :cleanup_call_list

#  after_initialize :default_values

  private
#  def default_values
#    self.oncall_candidate = true if self.oncall_candidate.nil?
#  end

  def cleanup_call_list
    CallEscalation.where(:call_list_id => call_list_id, :user_id => user_id).destroy_all
    OncallAssignment.where(:call_list_id => call_list_id, :user_id => user_id).destroy_all
  end
end
