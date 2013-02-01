require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NewsArticleFeed do
  before(:each) do
    @it_valid_attributes = {
      :name => "Irish Times News",
      :url => "http://rss.feedsportal.com/c/851/f/10846/index.rss",
      :check_period => 300, :next_check_after => Time.now, :source => 'i_t'
    }
    @indo_valid_attributes = {
      :name => "Independent World News",
      :url => "http://rss.independent.ie/c/32444/f/474628/index.rss",
      :check_period => 300, :next_check_after => Time.now, :source => 'indo'
    }
    @rte_valid_attributes = {
      :name => "RTE News Headlines",
      :url => "http://www.rte.ie/news/rss/news-headlines.xml",
      :check_period => 300, :next_check_after => Time.now, :source => 'rte'
    }
  end

  describe " given valid attributes" do
    context "IT" do
      it "creates a new feed instance" do
        NewsArticleFeed.create!(@it_valid_attributes)
      end
    end
    context "Indo" do
      it "creates a new feed instance" do
        NewsArticleFeed.create!(@indo_valid_attributes)
      end
    end
    context "RTE" do
      it "creates a new feed instance" do
        NewsArticleFeed.create!(@rte_valid_attributes)
      end
    end
  end

  describe "next_check_after" do
    it "should be set to asap on create" do
      a = NewsArticleFeed.create(@it_valid_attributes.merge(:next_check_after => nil))
      a.next_check_after.should be_within(10).of(Time.now)
    end

    it "should be set to Time.now + check_period when update_next_check_after is called" do
      a = NewsArticleFeed.create(@it_valid_attributes.merge(:next_check_after => nil))
      a.update_next_check_after!
      a.next_check_after.should be_within(10).of(Time.now + a.check_period)
    end
  end

  describe "due_check scope" do
    context "for IT" do
      it "should only return NewsArticleFeeds with a next_check_due in the past" do
        a = NewsArticleFeed.create!(@it_valid_attributes.merge(:next_check_after => Time.now + 5.minutes))
        b = NewsArticleFeed.create!(@rte_valid_attributes.merge(:next_check_after => Time.now - 60.minutes))
        NewsArticleFeed.due_check.collect { |a| a.next_check_after }.max.should < Time.now
      end
    end
  end


  describe "get_rss_entries" do
    context "for IT" do
      it "return hashes for each entry in the given rss feed xml" do
        entries = NewsArticleFeed.new.get_rss_entries(it_rss_feed_xml)
        entries.size.should == 73
        entries.first.should be_a Hash
        entries.collect { |e| e.class }.uniq.size.should == 1
      end

      it "return hashes with title, guid and link keys" do
        entry = NewsArticleFeed.new.get_rss_entries(it_rss_feed_xml).first
        entry[:title].should_not be_nil
        entry[:guid].should_not be_nil
        entry[:link].should_not be_nil
      end
    end

    context "for RTE" do
      it "return hashes for each entry in the given rss feed xml" do
        entries = NewsArticleFeed.new.get_rss_entries(rte_rss_feed_xml)
        entries.size.should == 25
        entries.first.should be_a Hash
        entries.collect { |e| e.class }.uniq.size.should == 1
      end

      it "return hashes with title, guid and link keys" do
        entry = NewsArticleFeed.new.get_rss_entries(rte_rss_feed_xml).first
        entry[:title].should_not be_nil
        entry[:guid].should_not be_nil
        entry[:link].should_not be_nil
      end
    end

    context "for Indo" do
      it "return hashes for each entry in the given rss feed xml" do
        entries = NewsArticleFeed.new.get_rss_entries(indo_rss_feed_xml)
        entries.size.should == 25
        entries.first.should be_a Hash
        entries.collect { |e| e.class }.uniq.size.should == 1
      end

      it "return hashes with title, guid and link keys" do
        entry = NewsArticleFeed.new.get_rss_entries(indo_rss_feed_xml).first
        entry[:title].should_not be_nil
        entry[:guid].should_not be_nil
        entry[:link].should_not be_nil
      end
    end
    it "should convert html entities in titles to utf8"

  end

  describe "create_from_rss" do
    context "for IT" do
      it "should create new NewsArticles when given rss feed data" do
        f = NewsArticleFeed.create!(@it_valid_attributes)
        articles = f.create_news_articles(it_rss_feed_xml)
        articles.size.should be_within(10).of(73)
        articles.first.should be_a_kind_of NewsArticle
        articles.collect { |e| e.class }.uniq.size.should == 1
        articles.first.new_record?.should == false
      end

      it "should set the source on new NewsArticles" do
        f = NewsArticleFeed.create!(@it_valid_attributes)
        articles = f.create_news_articles(it_rss_feed_xml)
        articles.first.source.should == @it_valid_attributes[:source]
      end

      # No requirement for feed filter in current implementation becuase of
      # targetted feeds. i.e., not sport or other uninteresting articles.

      # it "should not create NewsArticles for entries that match NewsArticleFeedFilters" do
      #   NewsArticleFeedFilter.create!(:name => "Sport", :url_filter => 'it')
      #   f = NewsArticleFeed.create!(@it_valid_attributes)
      #   articles = f.create_news_articles(it_rss_feed_xml)
      #   articles.size.should == 73
      # end
    end

    context "for RTE" do
      it "should create new NewsArticles when given rss feed data" do
        f = NewsArticleFeed.create!(@rte_valid_attributes)
        articles = f.create_news_articles(rte_rss_feed_xml)
        articles.size.should be_within(10).of(25)
        articles.first.should be_a_kind_of NewsArticle
        articles.collect { |e| e.class }.uniq.size.should == 1
        articles.first.new_record?.should == false
      end

      it "should set the source on new NewsArticles" do
        f = NewsArticleFeed.create!(@rte_valid_attributes)
        articles = f.create_news_articles(rte_rss_feed_xml)
        articles.first.source.should == @rte_valid_attributes[:source]
      end
    end

    context "for Indo" do
      it "should create new NewsArticles when given rss feed data" do
        f = NewsArticleFeed.create!(@indo_valid_attributes)
        articles = f.create_news_articles(indo_rss_feed_xml)
        articles.size.should be_within(10).of(25)
        articles.first.should be_a_kind_of NewsArticle
        articles.collect { |e| e.class }.uniq.size.should == 1
        articles.first.new_record?.should == false
      end

      it "should set the source on new NewsArticles" do
        f = NewsArticleFeed.create!(@indo_valid_attributes)
        articles = f.create_news_articles(indo_rss_feed_xml)
        articles.first.source.should == @indo_valid_attributes[:source]
      end
    end
  end


end
