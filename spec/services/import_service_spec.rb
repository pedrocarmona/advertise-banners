require "rails_helper"
require 'csv'

RSpec.describe ImportService do
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
      expect(Campaign.count).to be > 0
      expect(Click.count).to be > 0
      expect(Banner.count).to be > 0
      expect(Conversion.count).to be > 0
    end

  end
end
