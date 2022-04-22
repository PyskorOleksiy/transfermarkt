class AddForeignersToTournamentClub < ActiveRecord::Migration[6.1]
  def change
    add_column :tournament_clubs, :foreigners, :integer
  end
end
