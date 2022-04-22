class AddFootToPlayer < ActiveRecord::Migration[6.1]
  def change
    add_column :players, :foot, :string
  end
end
