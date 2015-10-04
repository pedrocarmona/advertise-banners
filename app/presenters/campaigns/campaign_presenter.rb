require "action_dispatch/middleware/session/cookie_store"

module Campaigns
  class CampaignPresenter < ActionDispatch::Session::CookieStore

    def initialize(campaign, session)
      @campaign = campaign
      @session = session
    end

    def current_banner
      @current_banner ||= get_next_banner
    end

  private
    def banners_queue
      @banners_queue ||= @session[:banners_queue]
      @banners_queue ||= @campaign.top_banners.map(&:id).shuffle
      @banners_queue
    end

    def get_next_banner
      banner = banners_queue.pop
      save_banners_queue
      banner
    end

    def save_banners_queue
      @banners_queue = nil if banners_queue.empty?
      @session[:banners_queue] = @banners_queue
    end
  end
end
