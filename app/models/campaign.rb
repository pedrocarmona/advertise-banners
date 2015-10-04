class Campaign < ActiveRecord::Base
  has_many :banners
  has_many :conversions, through: :banners

  def present_banners
    if most_profitable_banners_ids.size > 5
      return most_profitable_banners
    elsif most_profitable_banners_ids.size > 0
      return show_most_profitable_plus_most_clicked
    else
      return show_most_clicked_plus_random
    end
  end

  def show_most_profitable_plus_most_clicked
    first_part = most_profitable_banners
      second_part =
        most_clicked_banners.
        where.not(id: most_profitable_banners_ids).
        limit(5 - first_part.size)
    return first_part.push(*second_part)
  end

  def show_most_clicked_plus_random
    first_part = most_clicked_banners
    random_banner_ids =
      non_clicked_banners.
      pluck(:id).
      sample(5 - first_part.size)
    second_part =  banners.where("id IN(?)", random_banner_ids)
    return first_part.push(*second_part)
  end

  def non_clicked_banners
    banners.where.not(id: most_clicked_banners_ids)
  end

  def most_profitable_banners
    @most_profitable_banners ||= banners.most_profitable
  end

  def most_clicked_banners
    @most_clicked_banners ||= banners.most_clicked
  end

  def most_profitable_banners_ids
    @most_profitable_banners_ids ||= most_profitable_banners.map(&:id)
  end

  def most_clicked_banners_ids
    @most_clicked_banners_ids ||= most_clicked_banners.map(&:id)
  end


end


# select banners.campaign_id,clicks.banner_id, sum(revenue) from clicks
# join conversions on clicks.id=conversions.click_id
# join banners on banners.id=clicks.banner_id
# join campaigns on campaigns.id=banners.campaign_id
# where campaigns.id in (40,33,34)
# group by banner_id
# order by sum(revenue) DESC;

#Post.where("user_id IN (?)", args).to_a
