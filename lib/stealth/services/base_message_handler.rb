# coding: utf-8
# frozen_string_literal: true

module Stealth
  module Services
    class BaseMessageHandler

      attr_reader :params, :headers

      def initialize(params:, headers:)
        @params = params
        @headers = headers
      end

      # Should respond with a Rack response (https://github.com/sinatra/sinatra#return-values)
      def coordinate
        raise(Stealth::Errors::ServiceImpaired, "Service request handler does not implement 'process'")
      end

      # After coordinate responds to the service, an optional async job
      # may be fired that will continue the work via this method
      def process
      end

      def redis_backed_storage
        if !defined?($redis) || $redis.blank?
          raise(
            Stealth::Errors::RedisNotConfigured,
            "Please make sure REDIS_URL is configured before using backed storage"
          )
        end

        $redis
      end
    end
  end
end
