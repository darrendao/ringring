class CreateOncallAssignmentsGens < ActiveRecord::Migration
  def change
    create_table :oncall_assignments_gens do |t|
      t.datetime :last_gen
      t.integer :cycle_day
      t.time :cycle_time
      t.integer :call_list_id

      t.timestamps
    end
  end
end
