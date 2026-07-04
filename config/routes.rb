Rails.application.routes.draw do
  get "pages/top"
  get "up" => "rails/health#show", as: :rails_health_check

  root "pages#top"
end
