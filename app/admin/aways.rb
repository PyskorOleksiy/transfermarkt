ActiveAdmin.register Away do
  index do
    @away_matches = Away.all

    table do
      thead do
        tr do
          th do
            "Id"
          end
          th do
            "Tour"
          end
          th do
            "Match Date"
          end
          th do
            "Home team"
          end
          th do
            "Result"
          end
          th do
            "Away team"
          end
          th do
            "Created At"
          end
        end
      end
      tbody do
        @away_matches.each do |away_game|
          @tournament_club = TournamentClub.find_by(id: away_game.tournament_club_id)
          tr do
            td do
              away_game.id
            end
            td do
              away_game.tour
            end
            td do
              away_game.match_date.strftime("%d.%m.%Y %H:%M")
            end
            td do
              away_game.home_team
            end
            td do
              away_game.result
            end
            td do
              @tournament_club.club
            end
            td do
              away_game.created_at
            end
            td do
              strong { link_to "Show", admin_away_path(away_game) }
            end
            td do
              strong { link_to "Edit", edit_admin_away_path(away_game) }
            end
            td do
              strong { link_to 'Destroy', admin_away_path(away_game), method: :delete, data: { confirm: 'Are you sure?' } }
            end
          end
        end
      end
    end

    #actions
  end

  show do
    @away_match = Away.find(params[:id])
    @tournament_club = TournamentClub.find_by(id: @away_match.tournament_club_id)
    attributes_table do
      row :id do |r|
        @away_match.id
      end
      row :tour do |r|
        @away_match.tour
      end
      row :match_date do |r|
        @away_match.match_date
      end
      row :home_team do |r|
        @away_match.home_team
      end
      row :result do |r|
        @away_match.result
      end
      row :away_team do |r|
        @tournament_club.club
      end
    end
  end

  form do |f|
    tours = []
    1.upto(30) {|i| tours.push(i)}

    clubs_id = []
    @tournament_clubs = TournamentClub.order(:id)
    @tournament_clubs.each do |club|
      clubs_id.push(club.id)
    end
    home_teams = []
    @away_matches = Away.order(:home_team)
    @away_matches.each do |ag|
      home_teams.push(ag.away_team)
    end
    home_teams = home_teams.uniq

    if params[:action] == "new"
      f.inputs do
        f.input :tour, as: :select, collection: tours, selected: 1
        f.input :match_date
        f.input :home_team, as: :select, collection: home_teams, selected: home_teams[0]
        f.input :result
        f.input :tournament_club_id, as: :select, collection: clubs_id, selected: clubs_id[0]
      end
      f.actions

    elsif params[:action] == "edit"
      f.inputs do
        f.input :tour, as: :select, collection: tours
        f.input :match_date
        f.input :home_team, as: :select, collection: home_teams
        f.input :result
        f.input :tournament_club_id, as: :select, collection: clubs_id
      end
      f.actions
    end

    table_for TournamentClub.order(:place) do
      column :id
      column :club
    end
  end

  controller do
    def permitted_params
      params.permit away: [ :tour, :match_date, :home_team, :result, :tournament_club_id ]
    end
  end
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :tour, :home_team, :result, :away_team, :tournament_club_id, :match_date
  #
  # or
  #
  # permit_params do
  #   permitted = [:tour, :home_team, :result, :away_team, :tournament_club_id, :match_date]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
