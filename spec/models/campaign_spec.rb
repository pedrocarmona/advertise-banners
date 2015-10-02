require 'rails_helper'

RSpec.describe Campaign, type: :model do

  describe '#campaign show banners' do
    let(:campaign_with_revenue) { FactoryGirl.create(:campaign, :with_banner_and_clicks,  banner_count: 2, clicks_count_of_each_banner: 2, revenue_of_each_click: 0.2 ) }
    let(:campaign_with_just_clicks) { FactoryGirl.create(:campaign) }
    let(:campaign_without_clicks) { FactoryGirl.create(:campaign) }
#create(:user, :admin, :male, name: "Jon Snow")
    it "has one campaign in database" do
      campaign_with_revenue
      expect(Campaign.count).to eq 1
      expect(Banner.count).to eq 2
      expect(Click.count).to eq 4
      expect(Conversion.count).to eq 4
    end
  end

end
