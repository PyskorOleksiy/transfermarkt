class AddJoinedToPlayer < ActiveRecord::Migration[6.1]
  def change
    add_column :players, :joined, :date
  end
end
