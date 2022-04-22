class AddTotalMarketValueToTournamentClub < ActiveRecord::Migration[6.1]
  def change
    add_column :tournament_clubs, :total_market_value, :float
  end
end
