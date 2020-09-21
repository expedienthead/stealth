module Stealth
  class Controller
    module Sbootstrap
      # extend ActiveSupport::Concern

      # included do
      def my_test
        # service_client = Kernel.const_get("Stealth::Services::#{current_service.classify}::Client")
        # reply_handler = Kernel.const_get("Stealth::Services::#{current_service.classify}::ReplyHandler")
        reply_handler = reply_handler.new
        # reply = reply_handler.messenger_profile
        # client = service_client.new(
        #   reply: reply,
        #   endpoint: 'messenger_profile',
        #   access_token: current_page_info[:access_token]
        # )
        # client.transmit
      end
    end
  end
end
