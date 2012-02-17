class CreateCallEscalations < ActiveRecord::Migration
  def change
    create_table :call_escalations do |t|
      t.string :name
      t.string :number
      t.integer :position

      t.timestamps
    end
  end
end
