class CreateVacations < ActiveRecord::Migration
  def change
    create_table :vacations do |t|
      t.integer :user_id
      t.datetime :starts_at
      t.datetime :ends_at

      t.timestamps
    end
  end
end
