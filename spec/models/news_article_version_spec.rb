require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NewsArticleVersion do

  before(:each) do
    @it_valid_attributes = {
      :title => 'Egyptian activists take to streets ahead of poll',
      :source => 'it',
      :guid => 'http://rss.feedsportal.com/c/851/f/10846/s/26b2e105/l/0L0Sirishtimes0N0Cnewspaper0Cworld0C20A120C12180C12243279594540Bhtml/story01.htm',
      :url => 'http://rss.feedsportal.com/c/851/f/10846/s/26b2e103/l/0L0Sirishtimes0N0Cnewspaper0Cworld0C20A120C12180C12243279596980Bhtml/story01.htm',
      :parser => 'IrishtimesPageParserV1'
    }
    @more_valid_attributes = @it_valid_attributes.merge({ :guid => 'http://rss.feedsportal.com/c/851/f/10846/s/26b2e105/l/0L0Sirishtimes0N0Cnewspaper0Cworld0C20A120C12180C12243279594540Bhtml/story01.htm' })
    @expenses_row_article = @it_valid_attributes
  end

  it "should increment the version number for each new version" do
    na = it_news_article_with_two_versions
    versions = na.versions.collect { |v| v.version  }
    versions.max.should == 1
    versions.min.should == 0
  end
end
