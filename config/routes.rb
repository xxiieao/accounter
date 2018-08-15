# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  defaults format: :html do
    root to: 'data_service#index'
    resources :data_service, only: [:index]
    resources :transactions, only: %i[index edit update] do
      get  :unassorted, on: :collection
      post :purpose_confirm, on: :collection
      get  :preview, on: :collection
    end
    resources :purposes, except: %i[show new]
  end

  defaults format: :json do
    resources :data_service, only: [] do
      post :daily_aggregate, on: :collection
      post :consumption_aggregate, on: :collection
    end
    resources :transactions, only: [] do
      post :batch_create, on: :collection
    end
  end
end
