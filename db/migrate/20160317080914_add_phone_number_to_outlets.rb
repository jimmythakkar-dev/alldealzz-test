class AddPhoneNumberToOutlets < ActiveRecord::Migration
  def change
    add_column :outlets, :phone_number, :string
  end
end
