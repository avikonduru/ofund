class AddStock2ToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :stock2, :string, default: "808"
  end
end
