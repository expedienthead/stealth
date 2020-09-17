# coding: utf-8
# frozen_string_literal: true

module Stealth

  # Responsible for coordinating incoming messages
  #  1. Receives incoming request params
  #  2. Initializes respective service request handler
  #  3. Processes params through service request handler (might be async)
  #  4. Inits base StealthController with state params returned from the service
  #     request handler
  #  5. Returns an HTTP response to be returned to the requestor
  class Dispatcher

    attr_reader :service, :params, :headers, :message_handler

    def initialize(service:, params:, headers:)
      @service = service
      @params = params
      @headers = headers
      @message_handler = message_handler_klass.new(
        params: params,
        headers: headers
      )
    end

    def coordinate
      message_handler.coordinate
    end

    def process
      service_message = message_handler.process

      log_incoming_message(service_message) if Stealth.config.transcript_logging

      bot_controller = BotController.new(service_message: service_message)
      bot_controller.route
    # rescue Exception => ex
    #   Stealth::Logger.l(topic: "#{e.class}: #{e.message}", message: ex.backtrace.join("\n"))
    #   raise
    end

    private

      def message_handler_klass
        begin
          Kernel.const_get("Stealth::Services::#{service.classify}::MessageHandler")
        rescue NameError
          raise(Stealth::Errors::ServiceNotRecognized, "The service '#{service}' was not recognized")
        end
      end

      def log_incoming_message(service_message)
        return if service_message.blank?

        message = if service_message.location.present?
                    "Received: <user shared location>"
                  elsif service_message.attachments.present?
                    "Received: <user sent attachment>"
                  elsif service_message.payload.present?
                    "Received Payload: #{service_message.payload}"
                  else
                    "Received Message: #{service_message.message}"
                  end
        Stealth::Logger.l(
          topic: "user",
          message: "User #{service_message.sender_id} -> #{message}"
        )
      end
  end
end
