# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
NewsArticleFeed.create(:url => "http://www.rte.ie/news/rss/business-headlines.xml", :name => "RTE Business", :check_period => 300, :source => "rte")
NewsArticleFeed.create(:url => "http://www.rte.ie/news/rss/news-headlines.xml", :name => "RTE News", :check_period => 300, :source => "rte")
NewsArticleFeed.create(:url => "http://rss.feedsportal.com/c/851/f/10839/index.rss", :name => "Irish Times", :check_period => 300, :source => "irish_times")
NewsArticleFeed.create(:url => "http://rss.feedsportal.com/c/851/f/10841/index.rss", :name => "Irish Times Business", :check_period => 300, :source => "irish_times")
NewsArticleFeed.create(:url => "http://rss.feedsportal.com/c/851/f/10840/index.rss", :name => "Irish Times World", :check_period => 300, :source => "irish_times")
NewsArticleFeed.create(:url => "http://rss.independent.ie/c/32444/f/474628/index.rss", :name => "Indo World", :check_period => 300, :source => "independent")
NewsArticleFeed.create(:url => "http://www.independent.ie/breaking-news/national-news/rss", :name => "Indo Ire", :check_period => 300, :source => "independent")
