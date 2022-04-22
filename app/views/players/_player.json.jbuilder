json.extract! player, :id, :name, :position, :number, :age, :country, :contract_until, :created_at, :updated_at
json.url player_url(player, format: :json)
