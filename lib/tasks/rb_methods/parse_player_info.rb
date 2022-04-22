require 'date'

require './lib/tasks/rb_methods/input_space.rb'

def parse_player_info(player, tournament_club)
  #tournament_club.players.create(name: player_name.text)
  TournamentClub.order(:place)
  player_name = player.at_css('.hauptlink a').text.delete(" ").gsub(/\n/, '')
  pl_name = input_space(player_name)
  player_position = player.css('tr')[1].text.delete(" ").gsub(/\n/, '')
  if !player_position.include?("-")
    pl_position = input_space(player_position)
  else
    pl_position = player_position
  end
  player_number = player.at_css('.zentriert').text
  player_age = player.css('.zentriert')[1].text
  player_age_chars = player_age.chars
  i = player_age_chars.find_index("(")
  player_age = player_age[i+1..i+2].to_i
  player_country = player.at_css('.flaggenrahmen')['title']
  player_height = player.css('.zentriert')[3].text.gsub(',', '.').to_f
  player_foot = player.css('.zentriert')[4].text
  begin
    player_joined = Date.parse(player.css('.zentriert')[5].text)
  rescue Date::Error => error
    if error.message == "invalid date"
      player_joined = Date.new(0000, 1, 1)
    else
      abort("Date::Error: #{error.message}")
    end
  end
  begin
    player_last_club = player.css('.zentriert')[6].at_css('a')['title'].gsub('Ablöse', 'Transfer value =>')
  rescue NoMethodError => error
    if error.message == "undefined method `[]' for nil:NilClass"
      player_last_club = "-"
    else
      abort("NoMethodError: #{error.message}")
    end
  end
  begin
    player_contract_until = Date.parse(player.css('.zentriert')[7].text)
  rescue Date::Error => error
    if error.message == "invalid date"
      player_contract_until = Date.new(0000, 1, 1)
    else
      abort("Date::Error: #{error.message}")
    end
  end
  player_market_value = player.at_css('.rechts').text
  if player_market_value.include?("Th")
    player_market_value = player_market_value.delete("€Th").to_f
    player_market_value /= 1000
  else
    player_market_value = player_market_value.delete("€m").to_f
  end

  puts(pl_name)
  puts(pl_position)
  puts(player_number)
  puts(player_age)
  puts(player_country)
  puts(player_height)
  puts(player_foot)
  puts(player_joined)
  puts(player_last_club)
  puts(player_contract_until)
  puts(player_market_value)

  tournament_club.players.create(name: pl_name, position: pl_position, number: player_number, age: player_age, country: player_country, height: player_height, foot: player_foot,
                                 joined: player_joined, last_club: player_last_club, contract_until: player_contract_until, market_value: player_market_value)

  #if player_country != "Ukraine"
    #tournament_club.foreigners += 1
  #end
  #tournament_club.total_market_value += player_market_value
  #tournament_club.average_age += player_age
  TournamentClub.order(:place)
  tournament_club.save
end
