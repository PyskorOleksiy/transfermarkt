class CreatePlayers < ActiveRecord::Migration[6.1]
  def change
    create_table :players do |t|
      t.string :name
      t.string :position
      t.integer :number
      t.integer :age
      t.string :country
      t.date :contract_until
      t.references :tournament_club, null: false, foreign_key: true
      t.float :market_value
      t.string :cost_type
      t.string :last_club

      t.timestamps
    end
  end
end
