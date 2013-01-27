# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
NewsArticleFeed.create(:url => "http://www.rte.ie/news/rss/business-headlines.xml", :name => "RTE Business", :check_period => 300, :source => "rte business")
# NewsArticleFeed.create(:url => "http://rss.feedsportal.com/c/851/f/10839/index.rss", :name => "IrishTimes", :check_period => 300, :source => "irish_times ireland")
# NewsArticleFeed.create(:url => "http://rss.feedsportal.com/c/851/f/10841/index.rss", :name => "Irish Times Breaking Business", :check_period => 300, :source => "irish_times business")
# NewsArticleFeed.create(:url => "http://rss.feedsportal.com/c/851/f/10840/index.rss", :name => "Irish Times Breaking World", :check_period => 300, :source => "irish_times world")
NewsArticleFeed.create(:url => "http://www.rte.ie/news/rss/news-headlines.xml", :name => "RTE News", :check_period => 300, :source => "rte news")