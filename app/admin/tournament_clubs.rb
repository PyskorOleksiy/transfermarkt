ActiveAdmin.register TournamentClub do
  config.sort_order = 'place_asc'

  index do
    column :id
    column :place
    column :club
    column :points

    actions
  end

  show :title => :club do
    @tournament_club = TournamentClub.find(params[:id])
    attributes_table do
      row :id do |r|
        @tournament_club.id
      end
      row :club do |r|
        @tournament_club.club
      end
      row :english_name do |r|
        @tournament_club.english_name
      end
      row :founded do |r|
        @tournament_club.founded
      end
      row :stadium do |r|
        @tournament_club.stadium
      end
      row :squad_size do |r|
        @tournament_club.squad_size
      end
      row :national_team_players do |r|
        @tournament_club.national_team_players
      end
      row :foreigners do |r|
        @tournament_club.foreigners
      end
      row :average_age do |r|
        "#{'%.2f' % @tournament_club.average_age}"
      end
      row :total_market_value do |r|
        "€#{'%.2f' % @tournament_club.total_market_value}m"
      end
      row :achievements do |r|
        textarea do
          @tournament_club.achievements
        end
      end
    end

    panel 'Home games' do
      table do
        thead do
          tr do
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
          end
        end
        tbody do
          @tournament_club.homes.each do |home_game|
            tr do
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
      strong { link_to "New home game", new_admin_home_path }
    end

    panel 'Away games' do
      table do
        thead do
          tr do
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
          end
        end
        tbody do
          @tournament_club.aways.each do |away_game|
            tr do
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
      strong { link_to "New away game", new_admin_away_path }
    end

    panel 'PLayers' do
      table do
        thead do
          tr do
            th do
              "Name"
            end
            th do
              "Position"
            end
            th do
              "Number"
            end
            th do
              "Age"
            end
            th do
              "Height"
            end
            th do
              "Foot"
            end
            th do
              "Country"
            end
            th do
              "Joined"
            end
            th do
              "Contract until"
            end
            th do
              "Last Club"
            end
            th do
              "Market value"
            end
          end
        end
        tbody do
          players_order = @tournament_club.players.order(:position)
          players_order.each do |player|
            tr do
              td do
                player.name
              end
              td do
                player.position
              end
              td do
                player.number
              end
              td do
                player.age
              end
              td do
                "#{'%.2f' % player.height} m"
              end
              td do
                player.foot
              end
              td do
                player.country
              end
              td do
                player.joined
              end
              td do
                player.contract_until
              end
              td do
                player.last_club
              end
              td do
                "€#{'%.2f' % player.market_value}m"
              end
              td do
                strong { link_to "Show", admin_player_path(player) }
              end
              td do
                strong { link_to "Edit", edit_admin_player_path(player) }
              end
              td do
                strong { link_to 'Destroy', admin_player_path(player), method: :delete, data: { confirm: 'Are you sure?' } }
              end
            end
          end
        end
      end
      strong { link_to "New player", new_admin_player_path }
    end

    if (@tournament_club.coach)
      panel 'Coach' do
        table do
          thead do
            tr do
              th do
                "Id"
              end
              th do
                "Name"
              end
              th do
                "Club"
              end
              th do
                "Age"
              end
              th do
                "Country"
              end
              th do
                "Appointed"
              end
              th do
                "Contract until"
              end
              th do
                "Created At"
              end
            end
          end
          tbody do
            tr do
              td do
                @tournament_club.coach.id
              end
              td do
                @tournament_club.coach.name
              end
              td do
                @tournament_club.club
              end
              td do
                @tournament_club.coach.age
              end
              td do
                @tournament_club.coach.country
              end
              td do
                @tournament_club.coach.appointed
              end
              td do
                @tournament_club.coach.contract_until
              end
              td do
                @tournament_club.coach.created_at
              end
              td do
                strong { link_to "Show", admin_coach_path(@tournament_club.coach) }
              end
              td do
                strong { link_to "Edit", edit_admin_coach_path(@tournament_club.coach) }
              end
              td do
                strong { link_to 'Destroy', admin_coach_path(@tournament_club.coach), method: :delete, data: { confirm: 'Are you sure?' } }
              end
            end
          end
        end
      end
    else
      strong { link_to "New coach", new_admin_coach_path }
    end
  end

  form do |f|
    place = []
    1.upto(TournamentClub.count) {|i| place.push(i)}

    if params[:action] == "new"
      f.inputs do
        f.input :place, as: :select, collection: place, selected: 1
        f.input :club
        f.input :english_name
        f.input :points
        f.input :founded, as: :datepicker,
                      datepicker_options: {
                        min_date: "1860-1-1",
                        max_date: "2050-1-1"
                      }
        f.input :stadium
        f.input :national_team_players
        f.input :achievements, as: :text
      end
      f.actions

    elsif params[:action] == "edit"
      f.inputs do
        f.input :place, as: :select, collection: place
        f.input :club
        f.input :english_name
        f.input :points
        f.input :founded, as: :datepicker,
                      datepicker_options: {
                        min_date: "1860-1-1",
                        max_date: "2050-1-1"
                      }
        f.input :stadium
        f.input :national_team_players
        f.input :achievements, as: :text
      end
      f.actions
    end
  end

  # /admin/posts/:id/comments
  #member_action :players do
    #@players = resource.players
    # This will render app/views/admin/posts/comments.html.erb
  #end

  controller do

    def permitted_params
      params.permit tournament_club: [ :club, :english_name, :founded, :stadium, :squad_size, :national_team_players, :foreigners, :average_age, :total_market_value, :place, :points, :achievements ]
    end
  end

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :club, :points, :place
  #
  # or
  #
  # permit_params do
  #   permitted = [:club, :points, :place]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
end
