require 'r18n-core'
require 'pathname'
require_relative "rack-r18n/helpers"

module Rack
  class R18n
    # Avaible options:
    # :default => en
    # :place => "i18n"
    # Note: This is relative to #root
    attr_reader :options, :dirs
    def initialize(app, options = {})
      @app = app
      @options = options

      ::R18n::I18n.default = @options[:default] || "en"
      @options[:place] ||= "i18n"
      @dirs = Array(@options[:place]).map do |dir|
        (Pathname(root) + dir).expand_path
      end
    end

    def call(env)
      @env = env
      set_r18n
      @app.call(@env)
    end

    def set_r18n
      ::R18n.set do
        request = Rack::Request.new(@env)
        locales = ::R18n::I18n.parse_http(@env['HTTP_ACCEPT_LANGUAGE'])
        handle_session_locale(@env['rack.session'], locales, request.params[:locale])
        ::R18n::I18n.new(locales, @dirs)
      end
    end

    def handle_session_locale(session, locales, locale=nil)
      if locale
        if session
          session[:locale] = locale
        end
      elsif session[:locale]
        locale = session[:locale]
      end
      locales.insert(0, locale) if locale
    end

    def self.root
      @@root ||=  if defined? Merb
                    Merb.root
                  elsif defined? Sinatra
                    Sinatra.root
                  elsif defined? Rails
                    Rails.root
                  elsif defined? Rango
                    Rango.root
                  else
                    Dir.pwd
                  end
    end

    def self.root=(root)
      @@root = root
    end

  end
end
