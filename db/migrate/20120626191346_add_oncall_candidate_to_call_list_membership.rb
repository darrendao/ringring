class AddOncallCandidateToCallListMembership < ActiveRecord::Migration
  def change
    add_column :call_list_memberships, :oncall_candidate, :bool

  end
end
