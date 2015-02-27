Princess::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root to: 'yachts#index'

  resources 'rates', only: :index
  resources 'yachts', path: '/', only: :show
end
