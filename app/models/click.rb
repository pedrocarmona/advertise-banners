class Click < ActiveRecord::Base
  has_many :conversions
  belongs_to :banner
end
