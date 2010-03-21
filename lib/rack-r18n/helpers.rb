module Rack
  class R18n
    module Helpers
      def r18n
        R18n.get
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
