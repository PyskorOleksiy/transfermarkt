class AddEnglishNameToTournamentClub < ActiveRecord::Migration[6.1]
  def change
    add_column :tournament_clubs, :english_name, :string
  end
end
