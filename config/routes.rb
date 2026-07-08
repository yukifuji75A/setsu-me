Rails.application.routes.draw do
  devise_for :users
  resource :profile, only: [ :new, :create ]
  resource :common_answers, only: [ :edit, :update ], path: "common-answers"
  resource :mypage, only: [ :show ], controller: "mypage"

  get "up" => "rails/health#show", as: :rails_health_check

  root "mypage#show"
end
