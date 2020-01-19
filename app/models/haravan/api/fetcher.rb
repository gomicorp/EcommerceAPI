module Haravan
  module Api
    class Fetcher
      def fetch(path, **params)
        JSON.parse(faraday.get(path, params).body, symbolize_names: true)
      end

      private

      def faraday
        @conn ||= basic_auth(Faraday::Connection.new(haravan_host))
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

      def haravan_host
        Rails.application.credentials.dig(:haravan, :api, :host)
      end
    end
  end
end
