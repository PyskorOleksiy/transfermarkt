require 'open-uri'
require 'nokogiri'
require 'json'
require 'csv'

require './lib/tasks/rb_methods/parse_clubs_players_coaches.rb'

#Видалити Rake-task
Rake.application.instance_variable_get('@tasks').delete('take_from_csv:parse_tournament')
namespace :take_from_csv do
	url = 'https://www.transfermarkt.com/premier-liga/startseite/wettbewerb/UKR1'
	rel_direct = "https://www.transfermarkt.com"
	team_place = 0
	tournament = []
	matches = []

  desc "Parse UPL tournament table"
	task(parse_tournament: :environment) do
		url = 'https://upl.ua/ua/tournaments/championship/414/table'
		html = URI.open(url)
		doc = Nokogiri::HTML(html)

	  doc.css('tr').each do |football_team|
	    team = football_team.css('a').text
	    if (team == "")
	      next
	    end
	    team_place += 1
	    team_points = football_team.css('td').last.text.to_i
	    tournament.push(
	      place: team_place,
	      name: team,
	      points: team_points
	    )
		end
	end

	desc "Parse UPL match results"
	task(parse_matches: :environment) do
		url = 'https://upl.ua/ua/tournaments/championship/414/calendar'
    html = URI.open(url)
    doc = Nokogiri::HTML(html)
		rel_direct = "https://upl.ua"
		tour_match = 0
		tour = 1
		doc.css('.tour-match').each do |team_match|
			puts(tour)
			if tour_match == (team_place / 2)
				tour += 1
				tour_match = 0
			end
			home_team = team_match.at_css('.first-team').text.delete(' ').gsub(/\n/, '')
			away_team = team_match.at_css('.second-team').text.delete(' ').gsub(/\n/, '')
			result = team_match.at_css('.resualt').text.delete(' ').gsub(/\n/, '')
			match_href = team_match.css('.resualt a').map{ |link| link['href'] }.compact
			match_url = match_href[0]
			tour_match += 1
			if (!(result =~ /^[0-9][0-9]:[0-9][0-9]$/) && result != '-')
				url = rel_direct + match_url
			  html = URI.open(url)
			  doc = Nokogiri::HTML(html)
			  match_day = doc.css('.time').text
				matches.push(
					tour: tour,
					day: match_day,
					home: home_team,
					result: result,
					away: away_team
				)
			end
		 end
	end

	desc "Parse UPL players"
	task(parse_players: :environment) do
		Player.delete_all
		html = URI.open(url)
		doc = Nokogiri::HTML(html)
		#Parce clubs players links
		doc.css('tbody').each do |tr|
			row_odd = tr.css('.odd .hauptlink a')
			row_odd.each do |r|
				parse_club_squad_for_players(r, rel_direct)
			end
			row_even = tr.css('.even .hauptlink a')
			row_even.each do |r|
				parse_club_squad_for_players(r, rel_direct)
			end
		end
		TournamentClub.order(:place)
	end

	desc "Parse UPL coaches"
	task(parse_coaches: :environment) do
		Coach.delete_all
		html = URI.open(url)
		doc = Nokogiri::HTML(html)
		#Parce clubs coaches links
		doc.css('tbody').each do |tr|
			row_odd = tr.css('.odd .hauptlink a')
			row_odd.each do |r|
				parse_clubs_coaches(r, rel_direct)
			end
			row_even = tr.css('.even .hauptlink a')
			row_even.each do |r|
				parse_clubs_coaches(r, rel_direct)
			end
		end
		TournamentClub.order(:place)
	end

	desc "Write UPL tournament table, match results and players in csv files"
  task(:put_in_csv => [:parse_tournament, :parse_matches]) do
		CSV.open("lib/tasks/csv_files/tournament.csv", "w", headers: true) do |csv|
			t_headers = ["Місце", "Клуб", "Очки"]
			csv << t_headers
			for club in tournament do
				csv << club.values
			end
	  end

		CSV.open("lib/tasks/csv_files/UPL_matches.csv", "w", headers: true) do |csv|
	  	m_headers = ["Тур", "Дата", "Господарі", "Рахунок", "Гості"]
			csv << m_headers
			for game in matches do
				csv << game.values
			end
	  end
  end

	desc "Import UPL(Ukrainian Premier League) table data from tournament.csv and parse additional clubs data. Import home games and away games of the UPL team from UPL_matches.csv"
	task(tournament: :environment) do
		tournament_file = "lib/tasks/csv_files/tournament.csv"
		matches_file = "lib/tasks/csv_files/UPL_matches.csv"
		tournament_csv = CSV.read("lib/tasks/csv_files/tournament.csv")
		english_name_csv = CSV.read("lib/tasks/csv_files/UPLclubs_en_name.csv")

		if TournamentClub.count != tournament_csv.size - 1
			puts("Create")
			Home.delete_all
			Away.delete_all
			TournamentClub.delete_all

			english_name = ""
			CSV.foreach(tournament_file, :headers => true) do |row|
				english_name_csv.each do |en_name|
					if row[1] == en_name[0]
						english_name = en_name[1]
					end
				end
				TournamentClub.create ({ :place => row[0], :club => row[1], :points => row[2], :english_name => english_name })
		  end
			TournamentClub.order(:place)

			html = URI.open(url)
			doc = Nokogiri::HTML(html)
			#Parce clubs players links
			doc.css('tbody').each do |tr|
				row_odd = tr.css('.odd .hauptlink a')
				row_odd.each do |r|
					parse_club(r, rel_direct)
				end
				row_even = tr.css('.even .hauptlink a')
				row_even.each do |r|
					parse_club(r, rel_direct)
				end
			end

	    @tournament_clubs = TournamentClub.all
	    @homes = Home.all
	    @aways = Away.all
	    @tournament_clubs.each do |tournament_club|
				some_team = tournament_club.club
				some_team_chars = tournament_club.club.chars
				start_i = some_team_chars.find_index('«')
			  end_i = some_team_chars.find_index('»')
	      chosen_team = some_team[start_i+1..end_i-1].delete(' ')
		    CSV.foreach(matches_file, :headers => true) do |row|
		    	row[1] = row[1].delete(',').delete('і').gsub(/[а-я]/, '').gsub(/[А-Я]/, '')
		    	if (chosen_team == row[2].delete(' '))
						tournament_club.homes.create ({ :tour => row[0], :match_date => row[1], :home_team => row[2], :result => row[3], :away_team => row[4] })
						Home.order(:home_team)
					elsif (chosen_team == row[4].delete(' '))
						tournament_club.aways.create ({ :tour => row[0], :match_date => row[1], :home_team => row[2], :result => row[3], :away_team => row[4] })
						Away.order(:away_team)
	        end
	      end
	    end

		else
			CSV.foreach(tournament_file, :headers => true) do |row|
				if TournamentClub.exists?(club: row[1])
					tournament_club = TournamentClub.find_by(club: row[1])
					tournament_club.update(place: row[0], points: row[2])
					tournament_club.save
				else
					puts("Can't find club!")
				end
		  end
			TournamentClub.order(:place)
			puts("Update")
	  end
	end
end
