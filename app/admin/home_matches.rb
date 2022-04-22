ActiveAdmin.register HomeMatch do
  index do
    column :tour
    column :match_date
    column :tournament_club_id
    column :result
    column :away_team

    actions
  end

  show do
    attributes_table(:tour, :match_date, :tournament_club_id, :result, :away_team)
  end

  form do |f|
    f.inputs do
      f.input :tour
      f.input :match_date
      f.input :tournament_club_id
      f.input :result
      f.input :away_team
    end
    f.actions
  end

  controller do
    def permitted_params
      params.permit home_match: [ :tour, :match_date, :tournament_club_id, :result, :away_team ]
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
