require 'rails_helper'

RSpec.describe "campaigns/show", type: :view do
  before(:each) do
    @campaign = FactoryGirl.create(:campaign, :with_banners_of_several_types,
        banner_with_profit_count: 12, min_clicks_banner_with_profit: 1,
        max_clicks_banner_with_profit: 20, min_click_revenue_banner_with_profit: 0.1,
        max_click_revenue_banner_with_profit: 3.0, banner_with_clicks_count:1,
        min_clicks_banner_with_clicks: 1, max_clicks_banner_with_clicks: 20,
        banner_without_clicks_count: 1)
    @presenter = Campaigns::CampaignPresenter.new(@campaign, session)
  end
  it "Image should be different per request" do
    images = Set.new
    10.times do
      visit campaign_path(@campaign)
      image = page.first(:xpath, '//img')['alt']
      expect(images).to_not include(image)
      images << image
    end

  end

end
