Rails.application.routes.draw do
  devise_for :users
  resource :profile, only: [ :new, :create ]
  resource :common_answers, only: [ :edit, :update ], path: "common-answers"
  resource :mypage, only: [ :show ], controller: "mypage"

  resources :manuals, only: [ :show ] do
    collection do
      get   :step1
      post  :step1
      get   :step2
      # post  :step2
      get   :step3
      post  :step3, action: :step3_save
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check

  root "mypage#show"
end
