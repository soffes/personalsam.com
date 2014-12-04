Rails.application.routes.draw do
  root to: 'pages#home'

  get 'feed/sd', to: 'feeds#sd', format: 'xml', as: 'sd_feed'
  get 'feed/hd', to: 'feeds#hd', format: 'xml', as: 'hd_feed'
end
