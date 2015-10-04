module CampaignSpecHelper

  def campaign_most_profitable_banners_ids
    banners_with_profit = Hash.new
    campaign.banners.each do |banner|
      profit = banner.conversions.sum(:revenue)
      if (profit > 0)
        banners_with_profit[banner.id] = profit
      end
    end
    ordered = banners_with_profit.sort_by { |id, profit| profit }.reverse
    ordered = ordered[0..9] if ordered.size > 10
    return ordered.map{|array| array[0]}
  end

  def campaign_most_most_clicked_banners_ids
    banners_with_clicks = Hash.new
    campaign.banners.each do |banner|
      clicks = banner.clicks.size
      if (clicks > 0)
        banners_with_clicks[banner.id] = clicks
      end
    end
    ordered = banners_with_clicks.sort_by { |id, clicks| clicks }.reverse
    return ordered.map{|array| array[0]}
  end

  def the_most_profitable_plus_the_most_clicked_banners
    part_one = campaign_most_profitable_banners_ids
    part_two = (campaign_most_most_clicked_banners_ids - part_one)[0..(4-part_one.size)]
    return part_one | part_two
  end

  def non_clicked_banners
    return campaign.banners.where.not(id: campaign_most_most_clicked_banners_ids)
  end
end
