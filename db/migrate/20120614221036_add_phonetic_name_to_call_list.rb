class AddPhoneticNameToCallList < ActiveRecord::Migration
  def change
    add_column :call_lists, :phonetic_name, :string

  end
end
