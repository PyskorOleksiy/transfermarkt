class AddHeightToPlayers < ActiveRecord::Migration[6.1]
  def change
    add_column :players, :height, :float
  end
end
