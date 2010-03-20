require 'r18n-core'
require 'pathname'

module Rack
  class R18n
    # Avaible options:
    # :default => en
    # :dirs => "i18n"
    attr_reader :options, :dirs
    def initialize(app, options = {})
      @app = app
      @options = options

      ::R18n::I18n.default = @options[:default] || "en"
      @options[:dirs] ||= "i18n"
      @dirs = Array(@options[:dirs]).map do |dir|
        (Pathname(__FILE__).dirname + dir).expand_path
      end
    end

    def call(env)
      set_r18n(env)
      status, headers, body = @app.call(env)
      headers['Content-Language'] = locale
      [status, headers, body]
    end

    def set_r18n(env)
      request = Rack::Request.new(env)
      locales = ::R18n::I18n.parse_http(env['HTTP_ACCEPT_LANGUAGE'])
      locales.insert(0, request.params[:locale]) if request.params[:locale]
      ::R18n.set(::R18n::I18n.new(locales, @dirs))
    end

  end
end
