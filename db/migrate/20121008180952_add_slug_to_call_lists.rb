class AddSlugToCallLists < ActiveRecord::Migration
  def change
    add_column :call_lists, :slug, :string
    add_index :call_lists, :slug
  end
end
