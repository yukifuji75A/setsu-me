Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  resource :profile, only: [ :new, :create, :edit, :update ]
  resource :common_answers, only: [ :edit, :update ], path: "common-answers"
  resource :mypage, only: [ :show ], controller: "mypage"
  resource :account, only: [ :edit, :update ]
  get "terms", to: "static_pages#terms"
  get "privacy", to: "static_pages#privacy"

  resources :manuals, only: [ :show ] do
    collection do
      get   "step1/:theme", action: :step1, as: :step1
      post  "step1/:theme", action: :step1
      get   "step2/:theme", action: :step2, as: :step2
      get   "step3/:theme", action: :step3, as: :step3
      post  "step3/:theme", action: :step3_save
      get   "edit/:theme", action: :edit, as: :edit
      patch "edit/:theme", action: :update
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check

  root "mypage#show"
end
