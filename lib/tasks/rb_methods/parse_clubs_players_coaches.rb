require 'date'
require 'logger'

require './lib/tasks/rb_methods/parse_player_info.rb'

def parse_club(r, rel_direct)
  club_name = r['title']
  if TournamentClub.exists?(english_name: club_name)
    tournament_club = TournamentClub.find_by(english_name: club_name)
    puts(club_name)
    club_href = r['href']
    url = rel_direct + club_href
    html = URI.open(url)
    doc = Nokogiri::HTML(html)
    club_info_href = doc.at_css('.daten-und-fakten-verein .c2action-footer a')['href']
    url = rel_direct + club_info_href
    html = URI.open(url)
    doc = Nokogiri::HTML(html)
    #foreigners = doc.css('.dataDaten')[0].css('p')[2].at_css('.dataValue a').text.to_i
    national_team_players = doc.css('.dataDaten')[1].css('p')[0].at_css('.dataValue a').text.to_i
    stadium_name = doc.css('.dataDaten')[1].css('p')[1].at_css('.dataValue a').text
    stadium_seats = doc.css('.dataDaten')[1].css('p')[1].at_css('.dataValue span').text
    stadium = stadium_name + " " + stadium_seats
    founded = Date.new(0000, 1, 1)
    doc.css('.profilheader tr').each do |tr|
      if tr.at_css('th').text == "Founded:"
        founded = Date.parse(tr.at_css('td').text)
      end
    end
    club_achievements = ""
    begin
      achievements_href = doc.at_css('.dataTop .hide-for-small a')['href']
      achievement_url = rel_direct + achievements_href
      achievement_html = URI.open(achievement_url)
      achievement_doc = Nokogiri::HTML(achievement_html)
      achievement_doc.css('.row h2').each do |achievement|
        club_achievements += "#{achievement.text}\n"
      end
    rescue NoMethodError => error
      if error.message == "undefined method `[]' for nil:NilClass"
        club_achievements = "-"
      else
        abort("NoMethodError: #{error.message}")
      end
    end

    #puts(foreigners)
    puts(national_team_players)
    puts(stadium)
    puts(founded)
    puts(club_achievements)

    tournament_club.update(founded: founded, stadium: stadium, achievements: club_achievements, national_team_players: national_team_players)
    TournamentClub.order(:place)
    tournament_club.save
  end
end

def parse_club_squad_for_players(r, rel_direct)
  club_name = r['title']
  if TournamentClub.exists?(english_name: club_name)
    tournament_club = TournamentClub.find_by(english_name: club_name)
    #tournament_club.total_market_value = 0
    #tournament_club.average_age = 0
    #tournament_club.squad_size = 0
    #tournament_club.foreigners = 0
    puts(club_name)
    club_href = r['href']
    url = rel_direct + club_href
    url_split = url.split('/')
    new_url = ""
    url_split.each do |word|
      if word == "startseite"
        word = "kader"
      end
      new_url += word + '/'
    end
    new_url += "plus/1"
    html = URI.open(new_url)
    doc = Nokogiri::HTML(html)
    #Parce players info
    doc.css('.odd').each do |player|
      parse_player_info(player, tournament_club)
      #tournament_club.squad_size += 1
    end
    doc.css('.even').each do |player|
      parse_player_info(player, tournament_club)
      #tournament_club.squad_size += 1
    end
    #tournament_club.average_age /= tournament_club.players.size
    #tournament_club.total_market_value = tournament_club.total_market_value.round(2)
    #tournament_club.average_age = tournament_club.average_age.round(2)
    tournament_club.foreigners = tournament_club.players.where("country != 'Ukraine'").count
    tournament_club.squad_size = tournament_club.players.count
    tournament_club.average_age = tournament_club.players.average(:age)
    tournament_club.total_market_value = tournament_club.players.sum(:market_value)
    tournament_club.save
  end
end

def parse_clubs_coaches(r, rel_direct)
  club_name = r['title']
  if TournamentClub.exists?(english_name: club_name)
    tournament_club = TournamentClub.find_by(english_name: club_name)
    puts(club_name)
    club_href = r['href']
    url = rel_direct + club_href
    html = URI.open(url)
    doc = Nokogiri::HTML(html)
    #Parce coaches info
    coach_name = doc.at_css('.mitarbeiterVereinSlider .container-hauptinfo a').text
    coach_href = doc.at_css('.mitarbeiterVereinSlider .container-hauptinfo a')['href']
    coach_text = doc.at_css('.mitarbeiterVereinSlider .container-zusatzinfo').text
    coach_text_chars = coach_text.chars
    i = coach_text_chars.find_index(":")
    coach_age = coach_text[i+2..i+3].to_i
    coach_text = coach_text[i+3..coach_text.size-1]
    coach_text_chars = coach_text.chars
    i = coach_text_chars.find_index(':')
    coach_appointed = Date.parse(coach_text[i+2..i+13])
    coach_text = coach_text[i+13..coach_text.size-1]
    coach_text_chars = coach_text.chars
    i = coach_text_chars.find_index(':')
    coach_contract_until = Date.new(0000, 1, 1)
    begin
      coach_contract_until = Date.parse(coach_text[i+2..i+13])
    rescue Date::Error => error
      if error.message == "invalid date"
        coach_contract_until = Date.new(0000, 1, 1)
      else
        abort("Date::Error: #{error.message}")
      end
    end
    coach_country = doc.at_css('.mitarbeiterVereinSlider .container-zusatzinfo img')['title']
    url = rel_direct + coach_href
    html = URI.open(url)
    doc = Nokogiri::HTML(html)
    coach_avrg_term = doc.css('.dataDaten')[2].css('p')[1].at_css('.dataValue').text.delete("Years").delete(" ").to_f
    coach_pref_formation = doc.css('.dataDaten')[2].css('p')[2].at_css('.dataValue').text
    coach_last_club = doc.css('.responsive-table tbody tr')[1].css('td')[1].at_css('a').text
    coach_achievements = ""
    begin
      achievements_href = doc.at_css('.dataTop .hide-for-small a')['href']
      achievement_url = rel_direct + achievements_href
      achievement_html = URI.open(achievement_url)
      achievement_doc = Nokogiri::HTML(achievement_html)
      achievement_doc.css('.row h2').each do |achievement|
        coach_achievements += "#{achievement.text}\n"
      end
    rescue NoMethodError => error
      if error.message == "undefined method `[]' for nil:NilClass"
        coach_achievements = "-"
      else
        abort("NoMethodError: #{error.message}")
      end
    end

    puts(coach_name)
    puts(coach_age)
    puts(coach_country)
    puts(coach_appointed)
    puts(coach_contract_until)
    puts(coach_avrg_term)
    puts(coach_pref_formation)
    puts(coach_last_club)
    puts(coach_achievements)

    tournament_club.build_coach(name: coach_name, age: coach_age, country: coach_country, last_club: coach_last_club, contract_until: coach_contract_until,
                                   appointed: coach_appointed, average_term: coach_avrg_term, preferred_formation: coach_pref_formation, achievements: coach_achievements)
    TournamentClub.order(:place)
    tournament_club.save
  end
end
