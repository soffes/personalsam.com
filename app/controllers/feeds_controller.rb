class FeedsController < ApplicationController
  before_action :load_episodes

  def sd
    @type = :sd
    render template: 'feeds/podcast'
  end

  def hd
    @type = :hd
    render template: 'feeds/podcast'
  end

  private

  def load_episodes
    @episodes = Episode.order('published_at DESC')
  end
end
