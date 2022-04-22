class CreateAways < ActiveRecord::Migration[6.1]
  def change
    create_table :aways do |t|
      t.integer :tour
      t.string :home_team
      t.string :result
      t.string :away_team
      t.references :tournament_club, null: false, foreign_key: true
      t.datetime :match_date

      t.timestamps
    end
  end
end
