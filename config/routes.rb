Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  get "/", to: "routes#view"
  
  get "/pdf/ui/(:form_format)", to: "pdf#ui"
  get "/pdf/view", to: "pdf#view"
  post "/pdf/view", to: "pdf#view"
  get "/pdf/gzsl", to: "pdf#gzsl"
  
  get "/gzsl/ui/(:form_format)", to: "gzsl#ui"
  get "/gzsl/view", to: "gzsl#view"
  post "/gzsl/view", to: "gzsl#view"
  
  get "/qrcode/ui/(:form_format)", to: "qrcode#ui"
  get "/qrcode/create", to: "qrcode#create"
  post "/qrcode/create", to: "qrcode#create"
  get "/qrcode/view", to: "qrcode#view"
  post "/qrcode/view", to: "qrcode#view"
end
