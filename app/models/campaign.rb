class Campaign < ActiveRecord::Base
  has_many :banners
  has_many :conversions, through: :banners

  def decorate_campaign
    if most_profitable_banners.size > 5
      return only_profitable
    elsif most_profitable_banners.size > 0
      return show_most_profitable_plus_most_clicked
    else
      return show_most_clicked_plus_random
    end
  end

  def show_only_most_profitable_banners
    most_profitable_banners.limit(10)
  end

  def show_most_profitable_plus_most_clicked
    first_part = most_profitable_banners
      second_part =
        most_clicked_banners.
        where('id NOT IN (?)',most_profitable_banners_ids).
        limit(5 - first_part.size)
    return first_part.push(*second_part)
  end

  def show_most_clicked_plus_random
    first_part = most_clicked_banners
    random_banner_ids =
      banners.
      where('id NOT IN (?)',most_clicked_banners).
      pluck(:id).
      sample(5 - first_part.size)
    second_part =  banners.where("id IN(?)", random_banner_ids)
    return first_part.push(*second_part)
  end


  def most_profitable_banners
    banners.where('id IN (?)',most_profitable_banners_ids)
  end

  def most_clicked_banners
    banners.where('id IN (?)',most_clicked_banners_ids)
  end

  def most_profitable_banners_ids
    @most_profitable_banners_ids  ||= banners.most_profitable.map(&:id)
  end

  def most_clicked_banners_ids
    @most_clicked_banners_ids  ||= banners.most_clicked.map(&:id)
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
