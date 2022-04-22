class RemoveContractUntilFromPlayer < ActiveRecord::Migration[6.1]
  def change
    remove_column :players, :contract_until, :string
  end
end
