Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  get "/", to: "routes#view"
  
  get "/pdf/ui/(:output_format)", to: "pdf#ui"
  post "/pdf/ui/(:output_format)", to: "pdf#ui"
  post "/pdf/view", to: "pdf#view"
  post "/pdf/gzsl", to: "pdf#gzsl"
  
  get "/gzsl/ui/(:output_format)", to: "gzsl#ui"
  post "/gzsl/ui/(:output_format)", to: "gzsl#ui"
  post "/gzsl/view", to: "gzsl#view"
  
  get "/qrcode/ui/(:output_format)", to: "qrcode#ui"
  post "/qrcode/ui/(:output_format)", to: "qrcode#ui"
  post "/qrcode/create", to: "qrcode#create"
  post "/qrcode/view", to: "qrcode#view"
  
  get "/markdown/ui/(:output_format)", to: "markdown#ui"
  post "/markdown/ui/(:output_format)", to: "markdown#ui"
  post "/markdown/view", to: "markdown#view"
  post "/markdown/pdf", to: "markdown#pdf"
end
