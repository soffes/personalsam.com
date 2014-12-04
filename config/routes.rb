Rails.application.routes.draw do
  root to: 'pages#home'

  scope format: 'xml' do
    get 'feed/sd.xml', to: 'feeds#sd', as: 'sd_feed'
    get 'feed/hd.xml', to: 'feeds#hd', as: 'hd_feed'
  end
end
