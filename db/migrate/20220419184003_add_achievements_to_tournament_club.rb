class AddAchievementsToTournamentClub < ActiveRecord::Migration[6.1]
  def change
    add_column :tournament_clubs, :achievements, :text
  end
end
