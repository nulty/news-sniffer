# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true
end

def it_news_article(options = { })
  @guid_count = @guid_count.to_i + 1
  NewsArticle.create! @it_valid_attributes.merge(:guid => @guid_count).merge(options)
end

def it_news_page_html
  @it_news_page ||= File.read("spec/fixtures/web_pages/it_breaking2_A.html")
end

def it_news_page_html_with_a_change
  @it_news_page_with_a_change ||= File.read("spec/fixtures/web_pages/it_breaking2_B.html")
end

def it_news_page_html_with_no_title
  @it_news_page_html_with_no_title ||= File.read("spec/fixtures/web_pages/it_invalid_breaking2.html")
end

def it_news_article_with_one_version
  na = it_news_article
  p = WebPageParser::IrishtimesPageParserV1.new(:page => it_news_page_html)
  na.update_from_page(p)
  na.reload
end

def it_news_article_with_two_versions
  na = it_news_article
  p1 = WebPageParser::IrishtimesPageParserV1.new(:page => it_news_page_html)
  p2 = WebPageParser::IrishtimesPageParserV1.new(:page => it_news_page_html_with_a_change)
  na.update_from_page(p1)
  na.update_from_page(p2)
  na.reload
end

def it_rss_feed_xml
  @it_rss_feed_xml ||= File.read("spec/fixtures/rss_feeds/irishtimes.xml")
end

def indo_rss_feed_xml
  @indo_rss_feed_xml ||= File.read("spec/fixtures/rss_feeds/indo.xml")
end
def rte_rss_feed_xml
  @rte_rss_feed_xml ||= File.read("spec/fixtures/rss_feeds/indo.xml")
end
