module R18n
  module Rack
    module Helpers
      def r18n
        R18n.get
      end
      def t(*params)
        r18n.t(*params)
      end
    end
  end
end
