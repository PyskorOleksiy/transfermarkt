ActiveAdmin.register AwayMatch do
  index do
    column :tour
    column :match_date
    column :home_team
    column :result
    column :tournament_club_id

    actions
  end

  show do
    attributes_table(:tour, :match_date, :home_team, :result, :tournament_club_id)
  end

  form do |f|
    f.inputs do
      f.input :tour
      f.input :match_date
      f.input :home_team
      f.input :result
      f.input :tournament_club_id
    end
    f.actions
  end

  controller do
    def permitted_params
      params.permit away_match: [ :tour, :match_date, :home_team, :result, :tournament_club_id ]
    end
  end

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :tour, :home_team, :result, :away_team, :tournament_id, :match_date
  #
  # or
  #
  # permit_params do
  #   permitted = [:tour, :home_team, :result, :away_team, :tournament_id, :match_date]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
