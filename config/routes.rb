Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    get "/users/service", to: "users#service"
  end
  get ":slug" => "home#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  api_version(:module => "V1", :path => { :value => "v1" }) do
    get "/actuals/delete", to: "actuals#delete"
    get "/profiles/search", to: "profiles#search"
    #put "/profiles", to: "profiles#update"
    get "/profiles/mine", to: "profiles#mine"
    #get "/profiles/my/:id", to: "profiles#my"
    #post "/profiles/add_experties/:id", to: "profiles#add_experties"
    #post "/profiles/remove_experties/:id", to: "profiles#remove_experties"

    get "/posts/search", to: "posts#search"
    get "/posts/delete", to: "posts#destroy"

    get "/flyers/delete", to: "flyers#destroy"

    get "/channels/search", to: "channels#search"
    get "/channels/my", to: "channels#my"

    post "/roles/abilities", to: "roles#abilities"
    get "/roles/abilities/delete", to: "roles#remove_ability"

    get "/privacy/:id", to: "privacies#show"
    post "/privacy", to: "privacies#update"

    get "/comments/delete", to: "comments#destroy"
    get "/notifications", to: "notifications#my"
    post "/notifications", to: "notifications#seen"

    get "/bookmarks", to: "bookmarks#my"

    post "/notification_settings/add", to: "notification_settings#add"
    post "/notification_settings/remove", to: "notification_settings#remove"

    get "/users/role", to: "users#role"
    get "/users/user_info/:uuid", to: "users#user_info"
    post "/users/change_role", to: "users#change_role"

    get "/download/:uuid", to: "uploads#download"
    get "/uploads/delete", to: "uploads#destroy"
    get "/uploads/:uuid", to: "uploads#show"

    get "/uploads", to: "uploads#index"

    get "/tags/search", to: "tags#search"
    get "/tags/top", to: "tags#top"

    get "/attendances/delete", to: "attendances#destroy"
    get "/events/delete", to: "events#destroy"
    get "/meetings/delete", to: "meetings#destroy"
    get "/exhibitions/delete", to: "exhibitions#destroy"

    get "/exhibitions/related", to: "exhibitions#related"

    post "/attendances/change_duty", to: "attendances#change_duty"
    post "/attendances/attend", to: "attendances#attend"

    get "/events/tags", to: "events#tags"
    get "/events/meetings", to: "events#meetings"

    get "/meetings/join_bigblue/:id", to: "meetings#join_bigblue"
    get "/meetings/my", to: "meetings#my"
    get "/meetings/search", to: "meetings#search"

    get "/rooms/profile_display", to: "rooms#profile_display"

    get "/events/search", to: "events#search"
    get "/events/related", to: "events#related"
    get "/events/owner", to: "events#owner"
    get "/events/shortname_list", to: "events#shortname_list"
    get "/events/search_shortname", to: "events#search_shortname"

    get "/polls/overview/:id", to: "polls#overview"

    get "/exhibitions/search", to: "exhibitions#search"

    get "/polls/delete", to: "polls#destroy"

    resources :profiles
    resources :channels
    resources :posts
    resources :roles
    resources :shares
    resources :uploads
    resources :auxiliary_tables
    resources :auxiliary_records
    resources :interactions
    resources :users
    resources :comments
    resources :metas
    resources :actuals
    resources :friendships
    resources :settings
    resources :ratings
    resources :notification_settings
    resources :devices
    resources :rooms
    resources :participations
    resources :events
    resources :meetings
    resources :exhibitions
    resources :flyers
    resources :questions
    resources :attendances
    resources :tags
    resources :polls
    resources :pollings
    resources :abilities
    resources :questions

    post "/users/assignments", to: "users#assignments"
    get "/users/assignments/delete", to: "users#delete_assignment"
    post "/users/login", to: "users#login"
    post "/users/verify", to: "users#verify"
    post "/users/sign_up", to: "users#sign_up"
    post "/users/validate_token", to: "users#validate_token"
  end

  get "/", to: redirect("/ui/")

  #get '/', :to => redirect("app.html?rnd=#{SecureRandom.hex(10)}/#!/posts/")
  #get 'index.html', :to => redirect("/?rnd=#{SecureRandom.hex(10)}")
end
