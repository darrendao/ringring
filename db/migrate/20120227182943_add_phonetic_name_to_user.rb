class AddPhoneticNameToUser < ActiveRecord::Migration
  def change
    add_column :users, :phonetic_name, :string
  end
end
