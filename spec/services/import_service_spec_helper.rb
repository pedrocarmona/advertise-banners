require 'csv'
require 'set'

module ImportServiceSpecHelper
  CAMPAIGN_ID = 'campaign_id'
  BANNER_ID = 'banner_id'
  CLICK_ID = 'click_id'
  CONVERSION_ID = 'conversion_id'
  REVENUE = 'revenue'

  def campaigns_set
    # impressions_csv_path,clicks_csv_path must be variable in the implementation class
    @campaigns_set ||= create_set_from_csv(CAMPAIGN_ID,[impressions_csv_path, clicks_csv_path])
  end

  def banners_set
    # impressions_csv_path,clicks_csv_path must be variable in the implementation class
    @banners_set ||= create_set_from_csv(BANNER_ID,[impressions_csv_path,clicks_csv_path])
  end

  def clicks_set
    # impressions_csv_path,clicks_csv_path must be variable in the implementation class
    @clicks_set ||= create_set_from_csv(CLICK_ID,[clicks_csv_path,conversions_csv_path])
  end

  def conversions_set
    # impressions_csv_path,clicks_csv_path must be variable in the implementation class
    @conversions_set ||= create_set_from_csv(CONVERSION_ID,[conversions_csv_path])
  end

  def revenue_from_csv
    revenue = 0
    CSV.foreach(conversions_csv_path, {:row_sep => :auto, :headers => :first_row}) do | row |
      r = row[REVENUE].to_f
      revenue += r if r > 0.0
    end
    revenue
  end

  def create_set_from_csv(column,csv_files)
    set = Set.new
    csv_files.each do |csv_file|
      CSV.foreach(csv_file, {:row_sep => :auto, :headers => :first_row}) do | row |
        set.add(row[column]) if row[column].to_i > 0
      end
    end
    #puts "#{column}_set=#{set.to_a.join(', ')}"
    set
  end

end
