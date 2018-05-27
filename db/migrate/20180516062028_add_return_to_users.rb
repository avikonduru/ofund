class AddReturnToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :return, :float
  end
end
