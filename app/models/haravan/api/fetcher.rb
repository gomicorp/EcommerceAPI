module Haravan
  module Api
    class Fetcher
      include Core::Timer

      def fetch(path, **params)
        message = "  #{path.gsub('.json',' Load').gsub('/', '_').singularize.camelize} (:millisecond ms) ".cyan + " GET #{host_url}/#{path}?#{params.to_query}".blue
        measure_duration_feed(message, true) do
          parser.parse(faraday.get(path, params).body)
          # JSON.parse(faraday.get(path, params).body, symbolize_names: true)
        end
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
