class AddContractUntilToPlayer < ActiveRecord::Migration[6.1]
  def change
    add_column :players, :contract_until, :date
  end
end
