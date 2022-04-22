class RemoveFoundedFromTournamentClub < ActiveRecord::Migration[6.1]
  def change
    remove_column :tournament_clubs, :founded, :string
  end
end
