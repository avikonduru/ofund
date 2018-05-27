class AddStock1ToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :stock1, :string, default: "808"
  end
end
