require "rails_helper"

RSpec.describe MultipleWebsiteScrapper do
  describe "#fetch" do
    let(:urls) do
      %w[foo bar]
    end

    subject(:scrapper) { described_class.new(urls: urls) }
    let(:website_scrapper) { double }

    it "scraps all urls" do
      expect(website_scrapper).to receive(:fetch).exactly(2).times

      result = scrapper.fetch(website_scrapper)

      expect(result.valid?).to eq(true)
      expect(result.errors).to be_empty
    end

    context "when there are more than 3 urls" do
      let(:urls) do
        %w[foo bar zoo cat]
      end

      it "returns errors" do
        aggregate_failures do
          expect(website_scrapper).to_not receive(:fetch)

          result = scrapper.fetch(website_scrapper)

          expect(result.valid?).to eq(false)
          expect(result.errors).to eq(["Max 3 websites!"])
        end
      end
    end
  end

end
