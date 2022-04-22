class RemoveJoinedFromPlayer < ActiveRecord::Migration[6.1]
  def change
    remove_column :players, :joined, :string
  end
end
