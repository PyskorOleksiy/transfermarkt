class CreateCoaches < ActiveRecord::Migration[6.1]
  def change
    create_table :coaches do |t|
      t.string :name
      t.references :tournament_club, null: false, foreign_key: true
      t.integer :age
      t.string :country
      t.date :appointed
      t.date :contract_until
      t.float :average_term
      t.string :preferred_formation
      t.string :last_club
      t.text :achievements

      t.timestamps
    end
  end
end
