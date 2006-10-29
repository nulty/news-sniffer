require File.dirname(__FILE__) + '/../test_helper'

class HysThreadTest < Test::Unit::TestCase

  def test_rss
    assert HysThread.delete_all
    assert HysComment.delete_all
    assert_equal 0, HysThread.count
    assert HysThread.find_from_rss.size > 8, "didn't find enough threads from rss feed"
    assert HysThread.count > 8, "new threads from rss feed weren't created"
    before = HysThread.count
    assert HysThread.find_from_rss.size > 8, "didn't find enough threads from rss feed second time"
    assert_equal before, HysThread.count, "second run of find_from_rss created new threads (could be a race cond)"
    
    #t = HysThread.find(:first, :order => 'rand()')
    t = HysThread.find_by_bbcid(4522)
    assert t.bbcid.is_a?(Fixnum), "bbcid wasn't parsed"

    assert_equal 0, t.hys_comments.count, "thread already has comments!"
    comments = t.find_comments_from_rss
    assert_equal comments.size, comments.uniq.size, "rss feed had duplicates"
    assert_equal comments.size, t.hys_comments.count, "comments from rss weren't created in db"
    comments.first.destroy
    assert_equal comments.size - 1, t.hys_comments.count, "test comment wasn't destroyed"
    t = HysThread.find(t.id)
    t.rsssize = 0
    t.last_rss_pubdate = nil
    newcomments = t.find_comments_from_rss
    assert_equal comments.size, t.hys_comments.count, "deleted test comments wasn't found as new in feed"
  end
end
