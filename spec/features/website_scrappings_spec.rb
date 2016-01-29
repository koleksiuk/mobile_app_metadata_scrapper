require 'rails_helper'

RSpec.feature "WebsiteScrappings", type: :feature do
  let(:search_content) { urls.join("\n") }

  before do
    visit root_path

    fill_in :search_urls, with: search_content

    VCR.use_cassette("goodreads_facebook") do
      click_button "Fetch"
    end
  end

  context "when there are <= 3 urls" do
    let(:urls) do
      [
        'https://www.goodreads.com/book/show/3273.Moloka_i',
        'https://www.facebook.com/shortcutapp/?fref=ts'
      ]
    end

    it "scraps facebook website for metadata" do
      within "#results-#{urls[0].parameterize}" do
        expect(page).to have_link(urls[0])

        [
          "android",
          "ios",
          "Goodreads",
          "com.goodreads.https://book/show/3273",
          "355833469"
        ].each do |val|
          expect(page).to have_content(val)
        end
      end
    end

    it "scraps facebook website for metadata" do
      within "#results-#{urls[1].parameterize}" do
        expect(page).to have_link(urls[1])

        [
          "android",
          "com.facebook.katana",
          "fb://page/132622333546142",
          "fb://page/?id=132622333546142",
          "284882215"
        ].each do |val|
          expect(page).to have_content(val)
        end
      end
    end

    it "preserves text area box" do
      expect(find_field(:search_urls).value).to eq(search_content)
    end
  end
end
