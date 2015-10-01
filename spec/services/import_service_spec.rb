require "rails_helper"
require 'csv'

RSpec.describe ImportService do
  let(:service) { ImportService.new }

  describe '#import' do
    let(:impressions_csv_path) { Rails.root.join "csv/impressions_1.csv" }
    let(:clicks_csv_path) { Rails.root.join "csv/clicks_1.csv"}
    let(:conversions_csv_path) { Rails.root.join "csv/conversions_1.csv" }
    it 'it should import from CSV' do
      service.import(impressions_csv_path,clicks_csv_path,conversions_csv_path)
    end

  end
end
