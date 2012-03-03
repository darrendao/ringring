class CreatePhoneNumberInfos < ActiveRecord::Migration
  def change
    create_table :phone_number_infos do |t|
      t.integer :user_id
      t.string :number
      t.string :sms_gateway

      t.timestamps
    end
  end
end
