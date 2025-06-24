Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  root 'home#index'

  resources :doctors, only: [:new, :create, :show, :edit, :update] do
    resources :appointments, only: [:index, :show]  # Doctor’s view of appointments

    resources :patients, only: [:index, :new, :create, :show, :edit, :update] do
      resources :appointments, only: [:new, :create, :show] # Patient scheduling appointment
      resources :invoices, only: [:index, :new, :create, :show] do
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
    resources :audit_logs, only: [:index]
  end

  post "/stripe_checkout", to: "payments#stripe", as: :stripe_checkout
  post "/paypal_checkout", to: "payments#paypal", as: :paypal_checkout
  get  "/payments/stripe_success", to: "payments#stripe_success"
  get  "/payments/paypal_success", to: "payments#paypal_success"
  get  "/payments/paypal_cancel", to: "payments#paypal_cancel"

end
