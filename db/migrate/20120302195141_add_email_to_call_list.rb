class AddEmailToCallList < ActiveRecord::Migration
  def change
    add_column :call_lists, :email, :string
  end
end
