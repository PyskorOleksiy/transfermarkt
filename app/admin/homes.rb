ActiveAdmin.register Home do

  index do
    @home_matches = Home.all

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
        @home_matches.each do |home_game|
          @tournament_club = TournamentClub.find_by(id: home_game.tournament_club_id)
          tr do
            td do
              home_game.id
            end
            td do
              home_game.tour
            end
            td do
              home_game.match_date.strftime("%d.%m.%Y %H:%M")
            end
            td do
              @tournament_club.club
            end
            td do
              home_game.result
            end
            td do
              home_game.away_team
            end
            td do
              home_game.created_at
            end
            td do
              strong { link_to "Show", admin_home_path(home_game) }
            end
            td do
              strong { link_to "Edit", edit_admin_home_path(home_game) }
            end
            td do
              strong { link_to 'Destroy', admin_home_path(home_game), method: :delete, data: { confirm: 'Are you sure?' } }
            end
          end
        end
      end
    end

    #actions
  end

  show do
    @home_match = Home.find(params[:id])
    @tournament_club = TournamentClub.find_by(id: @home_match.tournament_club_id)
    attributes_table do
      row :id do |r|
        @home_match.id
      end
      row :tour do |r|
        @home_match.tour
      end
      row :match_date do |r|
        @home_match.match_date
      end
      row :home_team do |r|
        @tournament_club.club
      end
      row :result do |r|
        @home_match.result
      end
      row :away_team do |r|
        @home_match.away_team
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
    away_teams = []
    @home_matches = Home.order(:away_team)
    @home_matches.each do |hg|
      away_teams.push(hg.away_team)
    end
    away_teams = away_teams.uniq

    if params[:action] == "new"
      f.inputs do
        f.input :tour, as: :select, collection: tours, selected: 1
        f.input :match_date
        f.input :tournament_club_id, as: :select, collection: clubs_id, selected: clubs_id[0]
        f.input :result
        f.input :away_team, as: :select, collection: away_teams, selected: away_teams[0]
      end
      f.actions

    elsif params[:action] == "edit"
      f.inputs do
        f.input :tour, as: :select, collection: tours
        f.input :match_date
        f.input :tournament_club_id, as: :select, collection: clubs_id
        f.input :result
        f.input :away_team, as: :select, collection: away_teams
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
      params.permit home: [ :tour, :match_date, :tournament_club_id, :result, :away_team ]
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
