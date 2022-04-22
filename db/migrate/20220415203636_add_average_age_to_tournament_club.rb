class AddAverageAgeToTournamentClub < ActiveRecord::Migration[6.1]
  def change
    add_column :tournament_clubs, :average_age, :float
  end
end
