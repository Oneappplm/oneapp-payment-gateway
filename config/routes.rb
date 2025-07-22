Rails.application.routes.draw do
  
  root 'home#index'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  namespace :api do
    namespace :v1 do
      resources :users, only: [:create]
      resources :doctors do
        resources :patients do
          resources :invoices
        end
      end
    end
  end


  # namespace :api do
  #   namespace :v1 do
  #     resources :doctors
  #     resources :patients
  #     post 'users', to: 'registrations#create'
  #   end
  # end


  resources :doctors, only: [:index, :new, :create, :show, :edit, :update] do
    resources :appointments, only: [:index, :show]
    resources :invoices, only: [:index, :new, :create, :show]

    resources :patients, only: [:index, :new, :create, :show, :edit, :update] do
      resources :appointments, only: [:new, :create, :show] # Patient scheduling appointment
      resources :invoices, only: [:index, :new, :create, :show] do
        post :pay_with_medv, on: :member
        get :confirm_invoice_payment
        member do
          get :download_pdf
        end
      end
      resources :appointments, only: [:new, :create, :show]
    end

    resources :invoices, only: [:index, :show]
  end

  # resources :patients, only: [:index, :new, :create, :show, :edit, :update]

  namespace :admin do
    resources :wallets, only: [:index]
    resources :audit_logs, only: [:index]
  end

  resources :wallets, only: [:show] do
    collection do
      post :top_up
      get :scan_qr
    end

    member do
      get :transactions
    end
  end

  # post 'invoices/:id/pay_with_medv', to: 'invoices#pay_with_medv', as: :pay_with_medv

  get 'wallet_transactions', to: 'wallets#wallet_transactions'
  get 'qr_request', to: 'wallets#qr_request'

  get '/conversion_rate', to: 'conversion#medv_to_usd'
  post '/webhooks/stripe', to: 'payment_webhooks#stripe'

  post '/wallet_top_up/stripe', to: 'wallet_top_ups#stripe', as: :wallet_top_up_stripe
  get '/wallet_top_up/success', to: 'wallet_top_ups#stripe_success', as: :wallet_top_up_stripe_success

  post "/stripe_checkout", to: "payments#stripe", as: :stripe_checkout
  post "/paypal_checkout", to: "payments#paypal", as: :paypal_checkout
  get  "/payments/stripe_success", to: "payments#stripe_success"
  get  "/payments/paypal_success", to: "payments#paypal_success"
  get  "/payments/paypal_cancel", to: "payments#paypal_cancel"

end
