require "csv"

class ImportService
  BANNER_ID = 'banner_id'
  CAMPAIGN_ID = 'campaign_id'
  CLICK_ID = 'click_id'
  CONVERSION_ID = 'conversion_id'
  REVENUE = 'revenue'

  def import(impressions_csv_path,clicks_csv_path,conversions_csv_path)
    import_impressions(impressions_csv_path)
    import_clicks(clicks_csv_path)
    import_conversions(conversions_csv_path)
  end

  def import_impressions(impressions_csv_path)
    #row: banner_id,campaign_id
    CSV.foreach(impressions_csv_path, {:row_sep => :auto, :headers => :first_row}) do | row |
      find_or_create_banner_with_campaign(row[BANNER_ID],row[CAMPAIGN_ID])
    end
  end


  def import_clicks(clicks_csv_path)
    #row: click_id,banner_id,campaign_id
    CSV.foreach(clicks_csv_path, {:row_sep => :auto, :headers => :first_row}) do | row |
      banner = find_or_create_banner_with_campaign(row[BANNER_ID],row[CAMPAIGN_ID])
      click = Click.find_or_create_by(id:row[CLICK_ID])
      click.banner = banner
      click.save!
    end
  end

  def import_conversions(conversions_csv_path)
    #row: conversion_id,click_id,revenue
    CSV.foreach(conversions_csv_path, {:row_sep => :auto, :headers => :first_row}) do | row |
      click = Click.find_by_id(row[CLICK_ID])
      if (click != nil)
        conversion = Conversion.new(revenue: row[REVENUE])
        conversion.id = row[CONVERSION_ID]
        conversion.click = click
        conversion.save!
      end
    end
  end

  private
    def find_or_create_banner_with_campaign(banner_id, campaign_id)
      campaign = Campaign.find_or_create_by(id:campaign_id)
      campaign.save!
      banner = Banner.find_or_create_by(id:banner_id)
      banner.campaign = campaign
      banner.save!
      banner
    end

end
