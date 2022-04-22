require 'faker'

ActiveAdmin.register Player do

  #show do
    #attributes_table(:name, :tournament_club_id, :position, :number, :age, :country, :joined, :contract_until, :height, :foot, :last_club, :market_value)
  #end

  index do
    @players = Player.order(:tournament_club_id)

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
            "Position"
          end
          th do
            "Number"
          end
          th do
            "Age"
          end
          th do
            "Market Value"
          end
          th do
            "Created At"
          end
        end
      end
      tbody do
        @players.each do |player|
          @tournament_club = TournamentClub.find_by(id: player.tournament_club_id)
          if notice == "Player was successfully destroyed."
            #@tournament_club.foreigners = 0
            @tournament_club.foreigners = @tournament_club.players.where("country != 'Ukraine'").count
            #@tournament_club.average_age = 0
            #@tournament_club.total_market_value = 0
            @tournament_club.average_age = @tournament_club.players.average(:age)
            @tournament_club.total_market_value = @tournament_club.players.sum(:market_value)
            #@tournament_club.players.each do |player|
              #if player.country != "Ukraine"
                #@tournament_club.foreigners += 1
              #end
              #@tournament_club.average_age += player.age
              #@tournament_club.total_market_value += player.market_value
            #end
            @tournament_club.squad_size = @tournament_club.players.count
            @tournament_club.save
          end

          tr do
            td do
              player.id
            end
            td do
              player.name
            end
            td do
              @tournament_club.club
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
              "€#{'%.2f' % player.market_value}m"
            end
            td do
              player.created_at
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

    #actions
  end

  show do
    successfully = "Player was successfully "
    @player = Player.find(params[:id])
    @tournament_club = TournamentClub.find_by(id: @player.tournament_club_id)
    if notice == successfully + "created.updated." or notice == successfully + "updated."
      #@tournament_club.foreigners = 0
      @tournament_club.foreigners = @tournament_club.players.where("country != 'Ukraine'").count
      #@tournament_club.average_age = 0
      #@tournament_club.total_market_value = 0
      @tournament_club.average_age = @tournament_club.players.average(:age)
      @tournament_club.total_market_value = @tournament_club.players.sum(:market_value)
      #@tournament_club.players.each do |player|
        #if player.country != "Ukraine"
          #@tournament_club.foreigners += 1
        #end
        #@tournament_club.average_age += player.age
        #@tournament_club.total_market_value += player.market_value
      #end
      @tournament_club.squad_size = @tournament_club.players.count
      @tournament_club.save
    end

    attributes_table do
      row :id do |r|
        @player.id
      end
      row :name do |r|
        @player.name
      end
      row :tournament_club_id do |r|
        @tournament_club.club
      end
      row :position do |r|
        @player.position
      end
      row :number do |r|
        @player.age
      end
      row :height do |r|
        "#{'%.2f' % @player.height} m"
      end
      row :foot do |r|
        @player.foot
      end
      row :country do |r|
        @player.country
      end
      row :joined do |r|
        @player.joined
      end
      row :contract_until do |r|
        @player.contract_until
      end
      row :last_club do |r|
        @player.last_club
      end
      row :market_value do |r|
        "€#{'%.2f' % @player.market_value}m"
      end
    end
  end

  form do |f|
    positions = ["Goalkeeper", "Left-Back", "Right-Back", "Centre-Back", "Defensive Midfield", "Central Midfield", "Attacking Midfield", "Right Winger", "Left Winger", "Centre-Forward"]
    foots = ["left", "right", "both/left", "both/right"]
    date_joined = Date.new(2020, 1, 1)
    date_until = Date.new(2027, 1, 1)
    numbers = []
    1.upto(99) {|i| numbers.push(i)}
    clubs_id = []
    @tournament_clubs = TournamentClub.order(:id)
    @tournament_clubs.each do |club|
      clubs_id.push(club.id)
    end

    Faker::Address.unique.clear
    countries = []
    default_country = ""
    for item in 0..242
      faker = Faker::Address.unique.country
      countries.push(faker)
    end
    countries = countries.map { |c| Array(c).join(", ") }.sort

    if params[:action] == "new"
      f.inputs do
        f.input :name
        f.input :tournament_club_id, as: :select, collection: clubs_id, selected: clubs_id[0]
        f.input :position, as: :select, collection: positions, selected: "Goalkeeper"
        f.input :number, as: :select, collection: numbers, selected: 99
        f.input :age
        f.input :height, step: 0.01
        f.input :foot, as: :select, collection: foots, selected: "left"
        f.input :country, as: :select, collection: countries, selected: "Ukraine"
        f.input :joined, selected: date_joined
        f.input :contract_until, selected: date_until
        f.input :last_club
        f.input :market_value, value: number_with_precision(:market_value, precision: 2), step: 0.05
      end
      f.actions

    elsif params[:action] == "edit"
      f.inputs do
        f.input :name
        f.input :tournament_club_id, as: :select, collection: clubs_id
        f.input :position, as: :select, collection: positions
        f.input :number, as: :select, collection: numbers
        f.input :age
        f.input :height, step: 0.01
        f.input :foot, as: :select, collection: foots
        f.input :country, as: :select, collection: countries
        f.input :joined
        f.input :contract_until
        f.input :last_club
        f.input :market_value, value: number_with_precision(:market_value, precision: 2), step: 0.05
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
      params.permit player: [ :name, :tournament_club_id, :position, :number, :age, :country, :joined, :contract_until, :height, :foot, :last_club, :market_value ]
    end
  end
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name, :position, :number, :age, :country, :tournament_club_id, :market_value, :last_club, :height, :foot, :joined, :contract_until
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :position, :number, :age, :country, :tournament_club_id, :market_value, :last_club, :height, :foot, :joined, :contract_until]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
