require 'test_helper'

module Haravan
  module Api
    class FetcherTest < ActionDispatch::IntegrationTest
      test "Fetcher knows host_url" do
        fetcher = Fetcher.new
        host_url = fetcher.send(:host_url)
        assert_equal(host_url, fetcher.send(:faraday).url_prefix.to_s)
      end
    end
  end
end
