class Banner < ActiveRecord::Base
  has_many :clicks
  belongs_to :campaign
end
