Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'projects#index'
  resources :projects, only: [:index, :create, :edit, :update, :destroy] do
    resources :tasks, only: [:create, :edit, :update, :destroy] do
      member do
        post 'up'
        post 'down'
      end
      collection do
        post 'reorder'
      end
    end
  end
end
