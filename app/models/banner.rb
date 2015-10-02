class Banner < ActiveRecord::Base
  has_many :clicks
  belongs_to :campaign

  def self.create_or_update_from_csv(id, campaign)
    banner = Banner.find_or_create_by(id:id)
    banner.campaign = campaign
    banner.save!
    banner
  end
end
