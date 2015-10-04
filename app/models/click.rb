class Click < ActiveRecord::Base
  has_one :conversion
  belongs_to :banner
end
