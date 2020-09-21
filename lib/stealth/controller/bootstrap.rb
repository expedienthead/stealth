module Stealth
  class Controller
    module Bootstrap
      extend ActiveSupport::Concern

      included do

        def load_default_setup
          reply_handler = reply_handler.new
          reply = reply_handler.messenger_profile
          # client = service_client.new(
          #   reply: reply,
          #   endpoint: 'messenger_profile',
          #   access_token: current_page_info[:access_token]
          # )
          # client.transmit
        end

        private

        def service_client
          Kernel.const_get("Stealth::Services::#{current_service.classify}::Client")
        rescue NameError
          raise(Stealth::Errors::ServiceNotRecognized, "The service '#{current_service}' was not regconized")
        end

        def reply_handler
          Kernel.const_get("Stealth::Services::#{current_service.classify}::ReplyHandler")
        rescue NameError
          raise(Stealth::Errors::ServiceNotRecognized, "The service '#{current_service}' was not regconized")
        end
      end
    end
  end
end
