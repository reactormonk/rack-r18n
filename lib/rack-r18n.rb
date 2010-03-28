require 'r18n-core'
require 'pathname'

module Rack
  class R18n
    # Avaible options:
    # :default => en
    # :place => "i18n"
    # Note: This is relative to #root
    attr_reader :options, :place
    def initialize(app, options = {})
      @app = app
      @options = options

      ::R18n::I18n.default = @options[:default] || "en"
      @options[:place] ||= "i18n"
      @place = Array(@options[:place]).map do |dir|
        (Pathname(self.class.root) + dir).expand_path
      end
    end

    def call(env)
      @env = env
      ::R18n.thread_set {generate_r18n}
      @app.call(@env)
    end

    def generate_r18n
      request = Rack::Request.new(@env)
      locales = ::R18n::I18n.parse_http(@env['HTTP_ACCEPT_LANGUAGE'])
      if locale = session_locale(@env['rack.session'], locales, request.params[:locale])
        locale.insert(0, locale)
      end
      ::R18n::I18n.new(locales, @place)
    end

    def session_locale(session, locales, locale=nil)
      if locale
        if session
          session[:locale] = locale
        end
      elsif session && session[:locale]
        locale = session[:locale]
      end
      locale
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
