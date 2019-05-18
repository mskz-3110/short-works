Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  get "/", to: "routes#view"
  
  get "/pdf/ui/(:view_format)", to: "pdf#ui"
  get "/pdf/view", to: "pdf#view"
  post "/pdf/view", to: "pdf#view"
  get "/pdf/gzsl", to: "pdf#gzsl"
  
  get "/gzsl/ui/(:view_format)", to: "gzsl#ui"
  get "/gzsl/view", to: "gzsl#view"
  post "/gzsl/view", to: "gzsl#view"
end
