ActiveAdmin.register Coach do
  index do
    @coaches = Coach.order(:tournament_club_id)

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
        @coaches.each do |coach|
          @tournament_club = TournamentClub.find_by(id: coach.tournament_club_id)
          tr do
            td do
              coach.id
            end
            td do
              coach.name
            end
            td do
              @tournament_club.club
            end
            td do
              coach.age
            end
            td do
              coach.country
            end
            td do
              coach.appointed
            end
            td do
              coach.contract_until
            end
            td do
              coach.created_at
            end
            td do
              strong { link_to "Show", admin_coach_path(coach) }
            end
            td do
              strong { link_to "Edit", edit_admin_coach_path(coach) }
            end
            td do
              strong { link_to 'Destroy', admin_coach_path(coach), method: :delete, data: { confirm: 'Are you sure?' } }
            end
          end
        end
      end
    end
  end

  show do
    @coach = Coach.find(params[:id])
    @tournament_club = TournamentClub.find_by(id: @coach.tournament_club_id)

    attributes_table do
      row :id do |r|
        @coach.id
      end
      row :name do |r|
        @coach.name
      end
      row :tournament_club_id do |r|
        @tournament_club.club
      end
      row :age do |r|
        @coach.age
      end
      row :country do |r|
        @coach.country
      end
      row :preferred_formation do |r|
        @coach.preferred_formation
      end
      row :average_term do |r|
        @coach.average_term
      end
      row :appointed do |r|
        @coach.appointed
      end
      row :contract_until do |r|
        @coach.contract_until
      end
      row :last_club do |r|
        @coach.last_club
      end
      row :achievements do |r|
        textarea do
          @coach.achievements
        end
      end
    end
  end

  form do |f|
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

    formations = ["4-1-2-1-2", "4-3-3", "4-2-3-1", "4-4-2", "4-2-2-2", "4-2-1-3", "3-4-3", "3-5-2", "5-3-2", "5-4-1"]

    if params[:action] == "new"
      f.inputs do
        f.input :name
        f.input :tournament_club_id, as: :select, collection: clubs_id, selected: clubs_id[0]
        f.input :age
        f.input :country, as: :select, collection: countries, selected: "Ukraine"
        f.input :preferred_formation, as: :select, collection: formations, selected: formations[0]
        f.input :appointed
        f.inputs :contract_until
        f.input :last_club
        f.input :achievements
      end
      f.actions
    elsif params[:action] == "edit"
      f.inputs do
        f.input :name
        f.input :tournament_club_id, as: :select, collection: clubs_id
        f.input :age
        f.input :country, as: :select, collection: countries
        f.input :preferred_formation, as: :select, collection: formations
        f.input :appointed
        f.input :contract_until
        f.input :last_club
        f.input :achievements
      end
      f.actions
    end
  end

  controller do
    def permitted_params
      params.permit coach: [ :name, :tournament_club_id, :last_club, :age, :country, :appointed, :contract_until, :preferred_formation, :average_term, :last_club, :achievements ]
    end
  end
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name, :tournament_club_id, :age, :country, :appointed, :contract_until, :average_term, :preferred_formation, :last_club, :achievements
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :tournament_club_id, :age, :country, :appointed, :contract_until, :average_term, :preferred_formation, :last_club, :achievements]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
