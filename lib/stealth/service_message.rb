# coding: utf-8
# frozen_string_literal: true

module Stealth
  class ServiceMessage

    attr_accessor :sender_id, :target_id, :timestamp, :service, :message,
                  :location, :attachments, :payload, :referral,
                  :catch_all_reason, :page_info

    def initialize(service:)
      @service = service
      @attachments = []
      @location = {}
      @page_info = {}
    end
  end
end
