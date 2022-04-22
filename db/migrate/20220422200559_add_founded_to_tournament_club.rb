class AddFoundedToTournamentClub < ActiveRecord::Migration[6.1]
  def change
    add_column :tournament_clubs, :founded, :date
  end
end
