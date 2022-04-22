class ChangePlayersColumnsType < ActiveRecord::Migration
  def change
    change_table :players do |t|
      t.change :joined, :date
      t.change :contract_until, :date
    end
  end
end
