require "rails_helper"
require 'csv'
require_relative "./import_service_spec_helper"



RSpec.describe ImportService do
  include ImportServiceSpecHelper

  let(:service) { ImportService.new }

  describe '#import' do
    let(:impressions_csv_path) { Rails.root.join "spec/csv/impressions_1.csv" }
    let(:clicks_csv_path) { Rails.root.join "spec/csv/clicks_1.csv"}
    let(:conversions_csv_path) { Rails.root.join "spec/csv/conversions_1.csv" }
    it 'it should import from CSV' do
      expect(Campaign.count).to eq 0
      expect(Click.count).to eq 0
      expect(Banner.count).to eq 0
      expect(Conversion.count).to eq 0
      service.import(impressions_csv_path,clicks_csv_path,conversions_csv_path)
      # banners_set and campaigns_set created in spec helper
      expect(Campaign.count).to eq campaigns_set.size
      expect(Campaign.where("id in (?)", campaigns_set).size).to eq campaigns_set.size
      expect(Banner.count).to eq banners_set.size
      expect(Banner.where("id in (?)", banners_set).size).to eq banners_set.size
      expect(Click.count).to be == clicks_set.size
      expect(Conversion.count).to be == conversions_set.size
    end

  end
end
