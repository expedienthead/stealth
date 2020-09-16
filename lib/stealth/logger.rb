# coding: utf-8
# frozen_string_literal: true

module Stealth
  class Logger

    COLORS = ::Hash[
      black:        30,
      red:          31,
      green:        32,
      yellow:       33,
      blue:         34,
      magenta:      35,
      cyan:         36,
      gray:         37,
      light_cyan:   96,
      white:        97
    ].freeze

    @@logger ||= Logger.new("#{Stealth.log_path}/event.log")
    @@logger.datetime_format = "%Y-%m-%d %H:%M:%S"

    def self.color_code(code)
      COLORS.fetch(code) { raise(ArgumentError, "Color #{code} not supported.") }
    end

    def self.colorize(input, color:)
      "\e[#{color_code(color)}m#{input}\e[0m"
    end

    def self.log(topic:, message:)
      unless ENV['STEALTH_ENV'] == 'test'
        puts "TID-#{Stealth.tid} #{print_topic(topic)} #{message}"
      end
    end

    def self.print_topic(topic)
      topic_string = "[#{topic}]"

      color = case topic.to_sym
              when :session
                :green
              when :previous_session
                :yellow
              when :facebook, :twilio
                :blue
              when :smooch
                :magenta
              when :alexa
                :light_cyan
              when :catch_all
                :red
              when :user
                :white
              else
                :gray
              end
      colorize(topic_string, color: color)
    end

    class << self
      alias_method :l, :log
    end

  end
end
