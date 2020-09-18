module Stealth
  class Controller
    module CurrentSender
      extend ActiveSupport::Concern

      class Sender
        attr_accessor :name

        def initialize(name)
          @name = name
        end
      end

      included do
        def current_user
          redis_key = "#{current_service.try(:downcase)}:#{current_page_info[:id]}"
          user_name = $redis.hget(redis_key, 'name')
          user_name = user_profile[:name] if user_name.blank?
          @current_user ||= Stealth::Controller::CurrentSender::Sender.new(user_name)
        end
      end

      private

      def service_client
        Kernel.const_get("Stealth::Services::#{current_service.classify}::Client")
      rescue NameError
        raise(Stealth::Errors::ServiceNotRecognized, "The service '#{current_service}' was not regconized")
      end

      def user_profile
        profile = service_client.fetch_profile(recipient_id: current_user_id,
                                               access_token: current_page_info[:access_token])
        profile
      end
    end
  end
end
