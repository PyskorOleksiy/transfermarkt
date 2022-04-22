class AddSquadSizeToTournamentClub < ActiveRecord::Migration[6.1]
  def change
    add_column :tournament_clubs, :squad_size, :integer
  end
end
