class Conversion < ActiveRecord::Base
  belongs_to :click

  def self.create_or_update_from_csv(id, click, revenue)
    conversion = Conversion.find_by_id(id)
    if (!(conversion.is_a? Conversion))
      conversion = Conversion.new(revenue: revenue)
      conversion.id =  id
    end
    conversion.click = click
    conversion.save!
    conversion
  end
end
