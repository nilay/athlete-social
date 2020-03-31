require "sidekiq/web"
require "admin_constraint"

Rails.application.routes.draw do

  root "static#index"
  get "apple-app-site-association" => "static#apple_app_site_association"
  get "legal"           => "static#legal"
  get "tos"             => "static#tos"
  get "tos-app"         => "static#tos_app"
  get "athletes/eula"   => "static#athlete_eula", as: :athlete_eula
  get "fans/eula"       => "static#fan_eula",     as: :fan_eula

  get "/invite/:id",      to: "athletes#new",     as: :signup
  get "/posts/:id" => "posts#show"

  resources :athletes, only: [:new, :create, :deactivate, :destroy] do
    member do
      post :deactivate
      post :disable
      post :enable
    end

    collection do
      get :new_from_facebook
      get :create_from_facebook
    end
  end

  namespace :admin do
    get   "/sign-in",         to: "sessions#new",            as: :signin
    post  "/sign-in",         to: "sessions#create",         as: :authenticate
    get   "/sign-out",        to: "sessions#destroy",        as: :signout
    get   "/profile",         to: "profiles#me",             as: :profile
    get   "/edit_profile",    to: "profiles#edit",           as: :edit_profile
    patch "/update_profile",  to: "profiles#update",         as: :update_profile

    constraints AdminConstraint do
      mount Sidekiq::Web, at: "/sidekiq"
    end
    get "/sidekiq" => "sessions#new"

    resources :password_resets, path: :passwords, only: [:index, :create, :show, :update]

    resource :dashboard, only: [:show, :create], controller: "dashboard"

    resources :athletes do
      collection do
        post :activate
        post :deactivate
        delete :destroy
      end
    end

    resources :questions do
      collection do
        get :active
        get :inactive
        get :archived

        post :activate
        post :deactivate
        post :archive

        put :update
        delete :destroy
      end
    end

    resources :posts, only: :destroy

    resources :brands do
      collection do
        get :accounts
        get :questions
        get :campaigns
      end

      member do
        post :deactivate
        post :activate
      end
    end
    root to: redirect("/admin/questions")
  end

  namespace :api, defaults: { format: "json" } do
    namespace :v1 do
      get   '/sign-in/facebook',         to: 'facebook_sessions#new',          as: :new_facebook_session
      get   '/sign-in/facebook/create',  to: 'facebook_sessions#create',       as: :create_facebook_session
      post  "/sign-in",                  to: "sessions#create",                as: :sign_in
      post  "/sign-up",                  to: "users#create",                   as: :sign_up
      match "/sign-out",                 to: "sessions#destroy",               as: :sign_out,               via: [:post, :delete]
      get   "/me",                       to: "profiles#me",                    as: :profile
      patch "/update_me",                to: "profiles#update",                as: :update_profile
      post  "/confirm_avatar_upload",    to: "profiles#confirm_avatar_upload", as: :confirm_avatar
      patch "/deactivate",               to: "users#deactivate",               as: :deactivate
      patch "/activate",                 to: "users#activate",                 as: :activate

      resources :athletes, only: [:index, :show] do
        collection do
          get :top
          get :following
          get :search, to: 'athletes#index'
        end
        member do
          post :follow
          post :unfollow
        end
      end

      get '/athletes/:athlete_id/posts', to: 'posts#by_athlete'
      get '/athletes/:athlete_id/questions', to: 'questions#index'
      get '/athletes/:athlete_id/following', to: 'profiles#following', as: :following_athletes
      get '/athletes/:athlete_id/followers', to: 'profiles#followers', as: :followers_athletes
      get '/athletes/:athlete_id/reactions', to: 'profiles#reactions'
      get '/athletes/:athlete_id/answers', to: 'profiles#answers'
      get '/athletes/:athlete_id/liked_posts', to: 'profiles#liked_posts'
      get '/athletes/:athlete_id/liked_questions', to: 'profiles#liked_questions'
      get '/athletes/:athlete_id/metadata', to: 'profiles#metadata'

      resources :avatars,   only: [:new]

      get '/brands/:brand_id/questions', to: 'questions#index'
      get '/brands/:brand_id/following', to: 'profiles#following', as: :following_brands
      get '/brands/:brand_id/followers', to: 'profiles#followers', as: :followers_brands
      get '/brands/:brand_id/reactions', to: 'profiles#reactions'
      get '/brands/:brand_id/answers', to: 'profiles#answers'
      get '/brands/:brand_id/metadata', to: 'profiles#metadata'

      get '/fans/:fan_id/following', to: 'profiles#following', as: :following_fans
      get '/fans/:fan_id/liked_posts', to: 'profiles#liked_posts'
      get '/fans/:fan_id/liked_questions', to: 'profiles#liked_questions'
      get '/fans/:fan_id/metadata', to: 'profiles#metadata'

      resources :comments, only: [:create, :destroy]

      get '/intro', to: 'intro#index'

      resources :passwords, only: :create
      resources :posts, only: [:index, :show, :create, :update, :destroy] do
        resources :reactions, only: :show
        collection do
          get :top
          get :image_upload_url
        end
        member do
          post :shared_video
          post :flag
          post :like
          post :unlike
          post :dislike
          post :undislike
        end
      end

      resources :questions, only: [:index, :show, :create, :update, :destroy] do
        resources :reactions, only: :show
        member do
          post :like
          post :unlike
          post :dislike
          post :undislike
        end
      end

      resources :sessions,  only: [:create, :destroy]
      resources :users do
        collection do
          post :send_invite
          post :block_user
        end
      end

      resources :videos, only: [:new, :show] do
        collection do
          post :notifications
        end
      end
    end
  end

  namespace :athletes do
    get   "/profile",        to: "profiles#me",     as: :profile
    get   "/edit_profile",   to: "profiles#edit",   as: :edit_profile
    patch "/update_profile", to: "profiles#update", as: :update_profile

    resources :posts
  end
end
