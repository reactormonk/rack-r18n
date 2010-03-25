module Rack
  class R18n
    module Helpers
      unless method_defined?(:env)
        def env
          # general assumption - if your framework barks here, it sucks.
          request.env
        end
      end
      def r18n
        i18n = R18n.get || env['r18n.i18n']
      end
      def t(*params)
        r18n.t(*params)
      end
      def l(*params)
        r18n.l(*params)
      end
    end
  end
end
