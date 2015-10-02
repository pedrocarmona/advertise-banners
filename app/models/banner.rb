class Banner < ActiveRecord::Base
  has_many :clicks
  belongs_to :campaign
  has_many :conversions, through: :clicks
  scope :most_profitable, -> {
   joins(:conversions).
   select('banners.id, sum(revenue) total_revenue').
   group("banners.id").
   order('sum(revenue) desc')
  }
  # Banner.most_profitable.map(&:id)
  # Banner.most_profitable.map(&:total_revenue)
  scope :most_clicked, -> {
   joins(:clicks).
   select('banners.id, count(banner_id) total_clicks').
   group("banners.id").
   order('count(banner_id) desc')
  }
  # Banner.most_clicked.map(&:id)
  # Banner.most_clicked.map(&:total_clicks)

  def self.create_or_update_from_csv(id, campaign)
    banner = Banner.find_or_create_by(id:id)
    banner.campaign = campaign
    banner.save!
    banner
  end

  def total_revenue
    self.conversions.sum(:revenue)
  end
end

