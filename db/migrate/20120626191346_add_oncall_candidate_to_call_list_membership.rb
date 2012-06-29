class AddOncallCandidateToCallListMembership < ActiveRecord::Migration
  def change
    add_column :call_list_memberships, :oncall_candidate, :boolean

  end
end
