require 'rails_helper'
require_relative "./campaign_spec_helper"

RSpec.describe Campaign, type: :model do
  include CampaignSpecHelper

  describe '#campaign with three types of banners' do
    let(:campaign) { FactoryGirl.create(:campaign, :with_banners_of_several_types) }

    it "it should should have 3 banners" do
      expect(campaign.banners.count).to eq 3
    end

    it "it should should have 1 most profitable banner" do
      expect(campaign.banners.most_profitable.map(&:id).size).to eq 1
    end

    it "it should should have 2 most clicked banners" do
      expect(campaign.banners.most_clicked.map(&:id).size).to eq 2
    end

  end

  describe '#campaign with 12 profitable banners, plus one banner clicked without revenue and one banner not clicked,' do
    let(:campaign) {
      FactoryGirl.create(:campaign, :with_banners_of_several_types,
        banner_with_profit_count: 12, min_clicks_banner_with_profit: 1,
        max_clicks_banner_with_profit: 20, min_click_revenue_banner_with_profit: 0.1,
        max_click_revenue_banner_with_profit: 3.0, banner_with_clicks_count:1,
        min_clicks_banner_with_clicks: 1, max_clicks_banner_with_clicks: 20,
        banner_without_clicks_count: 1
      ) }

    it "should have 14 banners" do
      expect(campaign.banners.count).to eq 14
    end

    it "should have a list of 10 most profitable banner in descending order" do
      expect(campaign.most_profitable_banners_ids.size).to eq 10
      expect(campaign.most_profitable_banners_ids).to eq campaign_most_profitable_banners_ids
    end

    it "should have 13 most clicked banners" do
      expect(campaign.most_clicked_banners_ids.size).to eq 13
      expect(campaign.most_clicked_banners_ids.to_set).to eq campaign_most_most_clicked_banners_ids.to_set
    end

    it "presenter should show most profitable" do
      expect(campaign.top_banners.map(&:id)).to eq campaign_most_profitable_banners_ids
    end

  end

  describe '#campaign with 7 profitable banners, plus five banner clicked without revenue and one banner not clicked,' do
    let(:campaign) {
      FactoryGirl.create(:campaign, :with_banners_of_several_types,
        banner_with_profit_count: 7,
          min_clicks_banner_with_profit: 1, max_clicks_banner_with_profit: 20,
          min_click_revenue_banner_with_profit: 0.1, max_click_revenue_banner_with_profit: 3.0,
        banner_with_clicks_count:5,
          min_clicks_banner_with_clicks: 1, max_clicks_banner_with_clicks: 20,
        banner_without_clicks_count: 1
      ) }

    it "should have 13 banners" do
      expect(campaign.banners.count).to eq 13
    end

    it "should have a list of 7 most profitable banner in descending order" do
      expect(campaign.most_profitable_banners_ids.size).to eq 7
      expect(campaign.most_profitable_banners_ids).to eq campaign_most_profitable_banners_ids
    end

    it "should have a list of 12 most clicked banners" do
      expect(campaign.most_clicked_banners_ids.size).to eq 12
      expect(campaign.most_clicked_banners_ids.to_set).to eq campaign_most_most_clicked_banners_ids.to_set
    end

    it "presenter should show most profitable" do
      expect(campaign.top_banners.map(&:id)).to eq campaign_most_profitable_banners_ids
    end

  end

  describe '#campaign with 4 profitable banners, plus 10 banners clicked without revenue and one banner not clicked,' do
    let(:campaign) {
      FactoryGirl.create(:campaign, :with_banners_of_several_types,
        banner_with_profit_count: 4,
          min_clicks_banner_with_profit: 1, max_clicks_banner_with_profit: 20,
          min_click_revenue_banner_with_profit: 0.1, max_click_revenue_banner_with_profit: 3.0,
        banner_with_clicks_count:10,
          min_clicks_banner_with_clicks: 1, max_clicks_banner_with_clicks: 20,
        banner_without_clicks_count: 1
      ) }

    it "should have 15 banners" do
      expect(campaign.banners.count).to eq 15
    end

    it "should have a list of 4 most profitable banner in descending order" do
      expect(campaign.most_profitable_banners_ids.size).to eq 4
      expect(campaign.most_profitable_banners_ids).to eq campaign_most_profitable_banners_ids
    end

    it "should have a list of 14 most clicked banners" do
      expect(campaign.most_clicked_banners_ids.size).to eq 14
      expect(campaign.most_clicked_banners_ids.to_set).to eq campaign_most_most_clicked_banners_ids.to_set
    end

    it "presenter should show 5 banners (the most profitable with the most clicked) " do
      expect(campaign.top_banners.map(&:id)).to eq the_most_profitable_plus_the_most_clicked_banners
    end

  end

  describe '#campaign with 4 banners clicked without revenue and 10 banners not clicked,' do
    let(:campaign) {
      FactoryGirl.create(:campaign, :with_banners_of_several_types,
        banner_with_profit_count: 0,
        banner_with_clicks_count:4,
          min_clicks_banner_with_clicks: 1, max_clicks_banner_with_clicks: 20,
        banner_without_clicks_count: 12
      ) }
    let(:campaign2) {
      FactoryGirl.create(:campaign, :with_banners_of_several_types,
        banner_with_profit_count: 0,
        banner_with_clicks_count:4,
          min_clicks_banner_with_clicks: 1, max_clicks_banner_with_clicks: 20,
        banner_without_clicks_count: 12
      ) }

    it "should have 16 banners" do
      expect(campaign.banners.count).to eq 16
    end

    it "should have a list of 4 most clicked banners" do
      expect(campaign.most_clicked_banners_ids.size).to eq 4
      expect(campaign.most_clicked_banners_ids.to_set).to eq campaign_most_most_clicked_banners_ids.to_set
    end

    it "presenter should show 5 banners (the most clicked with random non clicked banners) " do
      expect(campaign.top_banners.map(&:id)[0..3]).to match_array(campaign_most_most_clicked_banners_ids)
      last_banner = campaign.top_banners.map(&:id)[4]
      expect(non_clicked_banners.map(&:id).to_set.include?(last_banner)).to be true
      expect(campaign.top_banners.map(&:id)).not_to eq (campaign2.top_banners.map(&:id))
    end

  end

  describe '#campaign with 20 banners not clicked,' do
    let(:campaign) {
      FactoryGirl.create(:campaign, :with_banners_of_several_types,
        banner_with_profit_count: 0,
        banner_with_clicks_count:0,
          min_clicks_banner_with_clicks: 1, max_clicks_banner_with_clicks: 20,
        banner_without_clicks_count: 20
      ) }
    let(:campaign2) {
      FactoryGirl.create(:campaign, :with_banners_of_several_types,
        banner_with_profit_count: 0,
        banner_with_clicks_count:0,
          min_clicks_banner_with_clicks: 1, max_clicks_banner_with_clicks: 20,
        banner_without_clicks_count: 20
      ) }

    it "should have 20 banners" do
      expect(campaign.banners.count).to eq 20
    end

    it "presenter should show 5 banners (with random non clicked banners) " do
      campaign.top_banners.each do |banner|
        expect(non_clicked_banners.map(&:id).to_set.include?(banner.id)).to be true
      end
      expect(campaign.top_banners.map(&:id)).not_to eq (campaign2.top_banners.map(&:id))
    end

  end

end
