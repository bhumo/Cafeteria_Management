# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  get "/cafeteria", to: "cafeteria#index"
  get "/signup", to: "registration#newUser"
  post "/signup", to: "registration#createUser"
  get "/login", to: "login#userlogin"
  get "/logout", to: "session#destroy"
  post "/login", to: "session#create"
  post "/addClerk", to: "registration#add_clerk"
end
