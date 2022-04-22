class AddStadiumToTournamentClub < ActiveRecord::Migration[6.1]
  def change
    add_column :tournament_clubs, :stadium, :string
  end
end
