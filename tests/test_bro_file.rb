require 'minitest'
require 'minitest/autorun'

require 'minitest/reporters'

MiniTest::Reporters.use!

require_relative '../lib/bro_file'

class TestMockChannelManager < MiniTest::Test

  def setup
    @path = File.join(File.dirname(__FILE__), "sample_data", "http.log")
    @bro_file = BroFile.new(@path)
  end

  # @todo Test the field extraction
  def test_can_extract_fields
    assert_equal("\\x09", @bro_file.separator, "Didn't extract separator correctly")
    assert_equal(",", @bro_file.set_separator, "Didn't extract set_separator correctly")
    assert_equal("(empty)", @bro_file.empty_field, "Didn't extract empty_field correctly")
    assert_equal("-", @bro_file.unset_field, "Didn't extract unset_field correctly")
    #assert_equal("2016-04-15-12-50-29", @bro_file.open_ts, "Didn't extract open_ts correctly")
    #assert_equal(["ts", "uid", "id.orig_h", "id.orig_p", "id.resp_h", "id.resp_p", "trans_depth", "method", "host", "uri", "referrer", "user_agent", "request_body_len", "response_body_len", "status_code", "status_msg", "info_code", "info_msg", "filename", "tags", "username", "password", "proxied", "orig_fuids", "orig_mime_types", "resp_fuids", "resp_mime_types", "post_body"], bro_file.fields, "Didn't extract fields correctly")
  end

  def test_can_extract_line
    record = @bro_file.get_line(1)
    assert_equal("1460742445.389561", record[0], "Didn't extract ts properly")

    record = @bro_file.get_line(1000)
    assert_nil(record, "Didn't get an empty line when should have")
  end

  def test_can_read_sequentially
    @bro_file.open!
    next_record = @bro_file.next_record
    assert_equal("1460742445.389561", next_record[0], "Didn't extract ts properly")
    next_record = @bro_file.next_record
    assert_equal("1460742499.633776", next_record[0], "Didn't extract ts properly")
    1000.times {@bro_file.next_record}
    next_record = @bro_file.next_record
    assert_nil(next_record, "Didn't return nil when no more lines were left")
  end

  def test_grouped_ts_on_field_name
    grouped_data = @bro_file.group_ts_by('host')
    puts grouped_data.inspect
  end

end