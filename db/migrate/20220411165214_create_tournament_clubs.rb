class CreateTournamentClubs < ActiveRecord::Migration[6.1]
  def change
    create_table :tournament_clubs do |t|
      t.string :club
      t.integer :points
      t.integer :place

      t.timestamps
    end
  end
end
