require "csv"

class ImportService
  CLICK_ID = 'click_id'
  BANNER_ID = 'banner_id'
  CAMPAIGN_ID = 'campaign_id'
  CONVERSION_ID = 'conversion_id'
  REVENUE = 'revenue'

  def import(impressions_csv_path,clicks_csv_path,conversions_csv_path)
    import_impressions(impressions_csv_path)
    import_clicks(clicks_csv_path)
    import_conversions(conversions_csv_path)
  end

  def import_impressions(impressions_csv_path)
    raise NotImplementedError
  end

  def import_clicks(clicks_csv_path)
    raise NotImplementedError
  end

  def import_conversions(conversions_csv_path)
    raise NotImplementedError
  end

end
