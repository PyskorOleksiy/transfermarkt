Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "tournament_clubs#index"

  #get '/admin/tournament_clubs/:id/players', to: 'admin/tournament_clubs#players'
  resources :tournament_clubs do
    resources :homes, :aways, :players, :coaches
  end
end
