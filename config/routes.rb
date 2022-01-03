Rails.application.routes.draw do
  devise_scope :user do
    get '/users/sign_in/otp' => 'users/otp/sessions#new'
    post '/users/sign_in/otp' => 'users/otp/sessions#create'
    get '/users/sign_in/recovery_code' => 'users/recovery_code/sessions#new'
    post '/users/sign_in/recovery_code' => 'users/recovery_code/sessions#create'
  end
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
  root "home#show"
  resource :dashboard, controller: :dashboard
  resource :two_factor_authentication do
    scope module: :two_factor_authentication do
      resource :confirmation
      resources :recovery_codes
    end
  end
end
