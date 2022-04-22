class AddNationalTeamPlayersToTournamentClub < ActiveRecord::Migration[6.1]
  def change
    add_column :tournament_clubs, :national_team_players, :integer
  end
end
