require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NewsArticle do

  before(:each) do
    @it_valid_attributes = {
      :title => 'State funeral of murdered garda held in Co Louth',
      :source => 'it',
      :guid => 'http://www.irishtimes.com/newspaper/breaking/2013/0129/breaking2.html',
      :url => 'http://www.irishtimes.com/newspaper/breaking/2013/0130/breaking2.html',
      :parser => 'IrishtimesPageParserV1'
    }
    @it_valid_attributes = @it_valid_attributes.merge({ :guid => 'http://www.irishtimes.com/newspaper/breaking/2013/0131/breaking2.html' })
    # @expenses_row_article = @valid_attributes
  end

  it "should create a new instance given valid attributes" do
    it_news_article
  end

  it "should create a NewsArticleVersion from the content of its web page" do
    na = it_news_article
    nav = na.update_from_source
    nav.should be_a_kind_of NewsArticleVersion
    na.versions.count.should == 1
  end

  it "should create a NewsArticleVersion when given a string containing html" do
    na = it_news_article
    p = WebPageParser::IrishtimesPageParserV1.new(:page => it_news_page_html)
    nav = na.update_from_page(p)
    nav.should be_a_kind_of NewsArticleVersion
    nav.new_record?.should == false
  end

  it "should not create a new NewsArticleVersion if it has not changed since the last check" do
    na = it_news_article_with_one_version
    p = WebPageParser::IrishtimesPageParserV1.new(:page => it_news_page_html)
    nav = na.update_from_page(p)
    nav.should be_nil
    na.versions.count.should == 1
  end

  it "should not create a new NewsArticleVersion if it has been seen more than once before already" do
    na = it_news_article
    p = WebPageParser::IrishtimesPageParserV1.new(:page => it_news_page_html)
    nav = na.update_from_page(p)
    nav.should be_a_kind_of NewsArticleVersion
    na.versions.count.should == 1
    p = WebPageParser::IrishtimesPageParserV1.new(:page => it_news_page_html_with_a_change)
    nav = na.update_from_page(p)
    nav.should be_a_kind_of NewsArticleVersion
    na.versions.count.should == 2
    p = WebPageParser::IrishtimesPageParserV1.new(:page => it_news_page_html)
    nav = na.update_from_page(p)
    nav.should be_a_kind_of NewsArticleVersion
    na.versions.count.should == 3
    p = WebPageParser::IrishtimesPageParserV1.new(:page => it_news_page_html_with_a_change)
    nav = na.update_from_page(p)
    nav.should be_a_kind_of NewsArticleVersion
    na.versions.count.should == 4
    p = WebPageParser::IrishtimesPageParserV1.new(:page => it_news_page_html)
    nav = na.update_from_page(p)
    nav.should == nil
    na.versions.count.should == 4
  end

  describe "next_check_after" do
    it "should default to asap on create" do
      it_news_article.next_check_after.should be_within(10).of(Time.now)
    end

    it "should be set to 30.minutes after the first version is found" do
      na = it_news_article
      p = WebPageParser::IrishtimesPageParserV1.new(:page => it_news_page_html)
      na.update_from_page(p)
      na.next_check_after.should be_within(10).of(Time.now + 30.minutes)
    end

    it "should be reset to 30 minutes when a new version is found" do
      na = it_news_article
      p1 = WebPageParser::IrishtimesPageParserV1.new(:page => it_news_page_html)
      na.update_from_page(p1)
      p2 = WebPageParser::IrishtimesPageParserV1.new(:page => it_news_page_html_with_a_change)
      na.update_from_page(p2)
      na.next_check_after.should be_within(10).of(Time.now + 30.minutes)
    end

    it "should increase by 20% when a check is made but a new version is not found" do
      na = it_news_article
      p = WebPageParser::IrishtimesPageParserV1.new(:page => it_news_page_html)
      period = 30.minutes
      30.times do
        na.update_from_page(p)
        na.next_check_after.should be_within(10).of(Time.now + period)
        period = (period * 1.2).round
      end
    end

    it "should increase when a check is made but a new version is invalid" do
      na = it_news_article
      p = WebPageParser::IrishtimesPageParserV1.new(:page => it_news_page_html_with_no_title)
      na.update_from_page(p)
      na.reload
      na.next_check_after.should be_within(10).of(Time.now + 30.minutes)
    end

  end

  it "should create a new version when its page content changes" do
    na = it_news_article_with_two_versions
    na.versions.count.should == 2
  end

  it "should update the latest_text_hash when a new version is created" do
    na = it_news_article_with_two_versions
    na.latest_text_hash.should == na.versions.find(:first, :order => 'id desc').text_hash
  end

  it "should increment the versions_count field when a new version is created" do
    na = it_news_article_with_two_versions
    na.versions_count.should == 2
  end

  it "should decrement the versions_count field when a new version is destroyed" do
    na = it_news_article_with_two_versions
    na.versions.first.destroy
    na.reload
    na.versions_count.should == 1
  end

  it "should count it's versions by hash" do
    na = it_news_article_with_two_versions
    p = WebPageParser::IrishtimesPageParserV1.new(:page => it_news_page_html)
    na.update_from_page(p)
    na.versions.count.should == 3
    na.count_versions_by_hash(na.versions[0].text_hash).should == 2
    na.count_versions_by_hash(na.versions[1].text_hash).should == 1
  end

  describe "due_check scope" do

    it "should exclude articles with a nil next_check_after field" do
      a = it_news_article
      a.update_attribute(:next_check_after, nil) # can't set this on create as it set pre-validation
      NewsArticle.count.should == 1
      NewsArticle.due_check.size.should == 0
    end

    it "should exclude articles over 40 days overdue" do
      a = it_news_article(:next_check_after => Time.now + 41.days)
      NewsArticle.due_check.size.should == 0
    end

    it "should order articles by how overdue an update they are" do
      now = Time.now
      a = it_news_article(:next_check_after => now - 1.hour)
      b = it_news_article(:next_check_after => now - 2.hours)
      NewsArticle.due_check.should == [b,a]
    end

    it "should not include articles not overdue an update yet" do
      now = Time.now
      a = it_news_article(:next_check_after => now - 1.hour)
      b = it_news_article(:next_check_after => now + 1.hour)
      NewsArticle.due_check.should == [a]
    end

  end
end
