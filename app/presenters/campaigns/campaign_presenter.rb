module Campaigns
  class CampaignPresenter

    def initialize(controller, campaign)
      @controller = controller
      @campaign = campaign
    end

    def current_banner
      @current_banner ||= get_next_banner
    end

  private
    def banners_queue
      @banners_queue = @controller.session[:banners_queue]
      @banners_queue ||= @campaign.present_banners.map(&:id).shuffle
    end

    def get_next_banner
      banner = banners_queue.pop
      save_banners_queue
      banner
    end

    def save_banners_queue
      @banners_queue = nil if banners_queue.empty?
      @controller.session[:banners_queue] = @banners_queue
    end
  end
end
