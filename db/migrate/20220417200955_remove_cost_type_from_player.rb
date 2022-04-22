class RemoveCostTypeFromPlayer < ActiveRecord::Migration[6.1]
  def change
    remove_column :players, :cost_type, :string
  end
end
