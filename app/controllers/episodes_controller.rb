class EpisodesController < ApplicationController
  def index
    @episodes = Episode.order('published_at DESC')
  end

  def show
    not_found and return unless @episode = Episode.where(slug: params[:slug]).first
  end
end
