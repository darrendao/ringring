class AddPositionToCallListMemberships < ActiveRecord::Migration
  def change
    add_column :call_list_memberships, :position, :integer

  end
end
