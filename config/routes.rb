Rails.application.routes.draw do
  root to: 'episodes#index'
  get ':slug', to: 'episodes#show', constraints: { slug: /[0-9]{4}-[0-9]{2}-[0-9]{2}/ }, as: 'episode'

  scope format: 'xml' do
    get 'feed/sd.xml', to: 'feeds#sd', as: 'sd_feed'
    get 'feed/hd.xml', to: 'feeds#hd', as: 'hd_feed'
  end
end
