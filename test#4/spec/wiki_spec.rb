require 'open-uri'
require 'nokogiri'

url = "https://fr.wikipedia.org/wiki/Ruby"

html_file = URI.open(url).read
html_doc = Nokogiri::HTML(html_file)

html_doc.search('h1').each do |element|
  context "test if first heading corresponds with page" do
    it "returns Ruby" do
      expect(element.text.strip).to eq("Ruby")
    end
  end
end
