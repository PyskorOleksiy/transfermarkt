class AddHeightToPlayer < ActiveRecord::Migration[6.1]
  def change
    add_column :players, :height, :string
  end
end
