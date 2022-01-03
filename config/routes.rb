Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
  root "home#show"
  resource :dashboard, controller: :dashboard
  resource :two_factor_authentication do
    scope module: :two_factor_authentication do
      resource :confirmation
    end
  end
end
