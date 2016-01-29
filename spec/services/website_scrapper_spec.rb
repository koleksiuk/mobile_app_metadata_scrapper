require "rails_helper"

RSpec.describe WebsiteScrapper do
  let(:meta) { '<meta name="title" value="test" />' }
  let(:body) do
    <<-HTML
      <html>
        <head>
          #{meta}
        </head>
      </html>
    HTML
  end

  describe "fake data" do
    let(:fetcher) { double }
    let(:store) { double('FakeStore', get_app_details: double) }
    let(:url) { "fake_url" }

    subject(:scrapper) { described_class.new(website_url: url, fetcher: fetcher, stores: [store]) }

    it "scraps data from given url" do
      expect(fetcher).to receive(:fetch).with(url) { double(body: "") }

      scrapper.fetch
    end

    describe "stores" do
      before do
        allow(fetcher).to receive(:fetch).with(url) { double(body: body) }
      end

      it "passes head xpath to each store" do
        expect(store).to receive(:get_app_details)

        scrapper.fetch
      end
    end
  end

  describe "integration test" do
    let(:scrapper) { described_class.new(website_url: url) }
    subject(:result) { scrapper.fetch }

    describe "pinterest" do
      let(:url) { "https://www.pinterest.com/pin/349380883571292829/" }

      it "scraps data successfully" do
        VCR.use_cassette("pinterest") do
          aggregate_failures do
            expect(result.count).to eq(2)

            expect(result[0].app_type).to eq(:android)
            expect(result[0].name).to eq("Pinterest")
            expect(result[0].store_id).to eq("com.pinterest")
            expect(result[0].url).to eq("pinterest://pin/349380883571292829")

            expect(result[1].app_type).to eq(:ios)
            expect(result[1].name).to eq("Pinterest")
            expect(result[1].store_id).to eq("429047995")
            expect(result[1].url).to eq("pinterest://pin/349380883571292829")
          end
        end
      end
    end

    describe "goodreads" do
      let(:url) { "https://www.goodreads.com/book/show/3273.Moloka_i" }

      it "returns only present data" do
        VCR.use_cassette("goodreads") do
          aggregate_failures do
            expect(result.count).to eq(1)

            expect(result[0].app_type).to eq(:ios)
            expect(result[0].name).to eq("Goodreads")
            expect(result[0].store_id).to eq("355833469")
            expect(result[0].url).to eq("com.goodreads.https://book/show/3273")
          end
        end
      end
    end
  end
end
