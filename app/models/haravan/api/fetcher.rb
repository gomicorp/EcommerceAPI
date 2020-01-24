module Haravan
  module Api
    class Fetcher
      def fetch(path, **params)
        parser.parse(faraday.get(path, params).body)
        # JSON.parse(faraday.get(path, params).body, symbolize_names: true)
      end

      private

      def faraday
        @conn ||= basic_auth(Faraday::Connection.new(host_url))
      end

      def parser
        @parser ||= Yajl::Parser.new(symbolize_keys: true)
      end

      def basic_auth(conn)
        conn.basic_auth(auth_username, auth_password)
        conn
      end

      def auth_username
        Rails.application.credentials.dig(:haravan, :api, :key)
      end

      def auth_password
        Rails.application.credentials.dig(:haravan, :api, :password)
      end

      def host_url
        Rails.application.credentials.dig(:haravan, :api, :host)
      end
    end
  end
end
