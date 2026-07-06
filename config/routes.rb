Rails.application.routes.draw do
  devise_for :users
  resource :profile, only: [:new, :create]
  get "up" => "rails/health#show", as: :rails_health_check

  root "pages#top"
end
